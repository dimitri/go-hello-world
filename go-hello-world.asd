;;;; go-hello-world.asd

(asdf:defsystem #:go-hello-world
  :serial t
  :description "Describe go-hello-world here"
  :author "Dimitri Fontaine <dim@tapoueh.org>"
  :license "WTFPL"
  :depends-on (#:lparallel)
  :components ((:file "package")
               (:file "go-hello-world")))

