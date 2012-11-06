;;;; package.lisp

(defpackage #:go-hello-world
  (:nicknames #:hello)
  (:use #:cl)
  (:export #:*hello-world-kernel*
	   #:hello-world
	   #:end-kernel))

;;;
;;; Some package names are a little too long to my taste and don't ship with
;;; nicknames, so use `rename-package' here to give them some new nicknames.
;;;
(loop for (package . nicknames)
     in '((lparallel lp)
	  (lparallel.queue lq))
     do (rename-package package package nicknames))

