(in-package :cl-user)
(defpackage webtest.model
  (:use :cl :sxql)
  (:import-from :webtest.db
                :db
                :with-connection
                :with-transaction) 
  (:import-from :datafly
                :execute
                :retrieve-all
                :retrieve-one)
  (:export :create-user-table
           :find-user
           :add-user
           :auth-user))

(in-package :webtest.model)

(defun create-user-table ()
  "Create user table if it doesn't exist yet."
  (with-connection (db)
    (execute
     (create-table (:user :if-not-exists t)
         ((id :type 'serial :primary-key t)
          (username :type 'text :not-null t :unique t)
          (password :type 'text :not-null t))))))

(defun add-user (uname pwd)
  "add user record to database."
  (with-connection (db)
    (execute
     (insert-into :user
       (set= :username uname            
             :password (cl-pass:hash pwd))))))

(defun find-user (uname)
  "lookup user record by username."
  (with-connection (db)
    (retrieve-one
     (select :*
       (from :user)
       (where (:= :username uname))))))

(defun auth-user (uname pwd)
  (let ((pwd-hash (getf (find-user uname) :password)))
    (if pwd-hash 
        (values (cl-pass:check-password pwd pwd-hash) uname)
        (values nil nil))))

