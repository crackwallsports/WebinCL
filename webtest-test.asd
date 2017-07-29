(in-package :cl-user)
(defpackage webtest-test-asd
  (:use :cl :asdf))
(in-package :webtest-test-asd)

(defsystem webtest-test
  :author "Xt3"
  :license ""
  :depends-on (:webtest
               :prove)
  :components ((:module "t"
                :components
                ((:file "webtest"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
