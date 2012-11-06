;;;; go-hello-world.lisp
;;;
;;; http://himmele.blogspot.de/2012/11/concurrent-hello-world-in-go-erlang.html
;;;

(in-package #:go-hello-world)

(defvar *hello-world-kernel* nil
  "The lparallel *kernel* we use in this package")

(defmacro with-temp-kernel ((nb-workers &key wait (name "hello-world"))
			    &body body)
  "Execute BODY with a temporary lparallel *kernel*, then ends it."
  `(progn
     (setf *hello-world-kernel* (lp:make-kernel ,nb-workers :name ,name))
     (let ((lp:*kernel* *hello-world-kernel*))
       (unwind-protect
	    (progn ,@body)
	 (lp:end-kernel :wait ,wait)))))

(defmacro with-temp-channel ((nb-workers channel-name &key wait) &body body)
  "Execute BODY with a temporary lparallel *kernel* of a single channel,
   then ends the kernel."
  `(with-temp-kernel (,nb-workers :wait ,wait)
     (let ((,channel-name (lp:make-channel)))
       ,@body)))

(defun end-kernel (&key wait)
  "End *hello-world-kernel*, for debugging purposes"
  (let* ((lp:*kernel* *hello-world-kernel*))
    (lp:end-kernel :wait wait)))

(defun say-hello (helloq worldq n)
  (dotimes (i n)
    (format t "Hello ")
    (lq:push-queue :say-world worldq)
    (lq:pop-queue helloq))
  (lq:push-queue :quit worldq))

(defun say-world (helloq worldq)
  (when (eq (lq:pop-queue worldq) :say-world)
    (format t "World!~%")
    (lq:push-queue :say-hello helloq)
    (say-world helloq worldq)))

(defun hello-world (n)
  (with-temp-channel (2 chan :wait t)
    (let* ((helloq       (lq:make-queue))
	   (worldq       (lq:make-queue)))
      (lp:submit-task chan #'say-world helloq worldq)
      (lp:submit-task chan #'say-hello helloq worldq n)
      (lp:receive-result chan)
      (lp:receive-result chan))))
