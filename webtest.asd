(in-package :cl-user)
(defpackage webtest-asd
  (:use :cl :asdf))
(in-package :webtest-asd)

(defsystem webtest
  :version "0.1"
  :author "Xt3"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop
               :cl-interpol
               :cl-syntax-interpol
               
               ;; for HTML CSS JS
               :plump
               :parenscript

               ;; for @route annotation
               ;; :cl-syntax-annot

               ;; for DB
               :datafly
               :sxql

               ;; Password hashing
               :cl-pass
               )
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "model"))
                 (:file "view" :depends-on ("config" "base"))
                 (:file "model" :depends-on ("db"))
                 (:file "db" :depends-on ("config"))
                 (:file "base")
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op webtest-test))))


