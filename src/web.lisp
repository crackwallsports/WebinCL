(in-package :cl-user)
(defpackage webtest.web
  (:use :cl
        :caveman2
        :webtest.config
        :webtest.view
        :webtest.db)
  (:export :*web*))
(in-package :webtest.web)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules
;; GET / 
(defroute "/" ()
  (lisp-render "index" '(:title "首页")))

;; GET /login
(defroute "/login" ()
  (lisp-render "login" '(:title "登录")))
;; POST /login
(defroute ("/login" :method :POST) (&key |uname| |upwd|)
  (if (equal |uname| "me")
      (if (equal |upwd| "pwd")
          (progn (setf (gethash :user *session*) "me")
                 (setf (response-status *response*) 200)
                 "")
          (progn (setf (gethash :error *session*) "密码错误")
                 (setf (response-status *response*) 500)
                 ""))
      (progn (setf (gethash :error *session*) "用户名错误")
             (setf (response-status *response*) 500)
             "")))

;; GET /register
(defroute "/register" ()
  (lisp-render "register" '(:title "注册")))
;; POST /register
(defroute ("/register" :method :POST) (&key |uname| |upwd|)
  (if (and (equal |uname| "me")
           (equal |upwd| "pwd"))
      (progn (setf (gethash :error *session*) "成功")
             (setf (response-status *response*) 200)
             "")
      (progn (setf (gethash :error *session*) "失败")
             (setf (response-status *response*) 500)
             "")))

;; GET /home
(defroute "/home" ()
  (if (gethash :user *session*)
      (lisp-render "home" `(:title "主页" :user ,(gethash :user *session*)))
      (progn (setf (gethash :error *session*) "请登录")
             (redirect "/login")
             ""))
  )

;; GET /logout
(defroute "/logout" ()
  (setf (gethash :user *session*) nil)
  (setf (gethash :error *session*) nil)
  (redirect "/")
  )


;;
;; Error pages
(defmethod on-exception ((app <web>) code)
  (declare (ignore app))
  #?"ERROR: ${code}"
  ;; (lisp-render (error-page code))
  )
