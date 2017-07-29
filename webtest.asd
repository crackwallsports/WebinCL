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
               ;; for HTML CSS JS
               :plump
               :parenscript
               :cl-interpol
               :cl-syntax-interpol
               ;; for DB
               :datafly
               )
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config" "base"))
                 (:file "db" :depends-on ("config"))
                 (:file "base")
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op webtest-test))))


