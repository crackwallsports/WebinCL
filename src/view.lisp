(in-package :cl-user)
(defpackage webtest.view
  (:use :cl :webtest.base)
  (:import-from :webtest.config
                :*template-directory*)
  (:import-from :caveman2
                :*response*
                :response-headers)
  (:import-from :datafly
                :encode-json)
  (:export :lisp-render
           :render-json))
(in-package :webtest.view)


(defparameter *template-registry* (make-hash-table :test 'equal))


(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (encode-json object))

(defparameter *args* ())
(defun merge-args (us them)
  (loop for (k v) on us by #'cddr
     do (let ((p (position k them)))
          (unless (null p)
            (setf (elt them (1+ p)) v))))
  them)

(defun lisp-render (path &optional args)
  (let ((*default-pathname-defaults* *template-directory*))
    (setf *args* args)
    (load path))
  (->html
   (funcall (intern (string-upcase #?"${path}-page") :webtest.view))))

