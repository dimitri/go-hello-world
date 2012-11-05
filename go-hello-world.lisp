;;;; go-hello-world.lisp
;;;
;;; http://himmele.blogspot.de/2012/11/concurrent-hello-world-in-go-erlang.html
;;;

(in-package #:go-hello-world)

(defvar *hello-world-kernel* (lp:make-kernel 2))

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
  (let* ((lp:*kernel*  *hello-world-kernel*)
	 (channel      (lp:make-channel))
	 (helloq       (lq:make-queue))
	 (worldq       (lq:make-queue)))
    (lp:submit-task channel #'say-world helloq worldq)
    (lp:submit-task channel #'say-hello helloq worldq n)
    (lp:receive-result channel)
    (lp:end-kernel)))
