(in-package :cl-user)
(defpackage webtest.web
  (:use :cl
        :caveman2
        :webtest.config
        :webtest.view
        :webtest.db
        :webtest.model)
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
  (if (gethash :user *session*)
      (lisp-render "home" `(:title "主页" :user ,(gethash :user *session*)))
      (lisp-render "index" '(:title "首页"))))

;; GET /login
(defroute "/login" ()
  (lisp-render "login" '(:title "登录")))
;; POST /login
(defroute ("/login" :method :POST) (&key |uname| |upwd|)
  (multiple-value-bind (pwdp unamep) (auth-user |uname| |upwd|)
    (cond
      (pwdp (setf (gethash :user *session*) |uname|)
            (setf (response-status *response*) 200)
            "成功")
      (unamep (setf (gethash :error *session*) "密码错误")
              (setf (response-status *response*) 500)
              "密码错误")
      (t (setf (gethash :error *session*) "用户名和密码错误")
         (setf (response-status *response*) 500)
         "用户名和密码错误"))))

;; GET /register
(defroute "/register" ()
  (lisp-render "register" '(:title "注册")))
;; POST /register
(defroute ("/register" :method :POST) (&key |uname| |upwd|)
  (if (find-user |uname|)
      (progn
        (setf (gethash :error *session*) "用户名存在")
        (setf (response-status *response*) 500)
        "用户名存在")
      (progn
        (add-user |uname| |upwd|)
        (setf (response-status *response*) 200)
        "注册成功")))

;; GET /home
(defroute "/home" ()
  (if (gethash :user *session*)
      (lisp-render "home" `(:title "主页" :user ,(gethash :user *session*)))
      (progn (setf (gethash :error *session*) "请登录")
             (redirect "/login")
             "")))

;; GET /logout
(defroute "/logout" ()
  (setf (gethash :user *session*) nil)
  (setf (gethash :error *session*) nil)
  (redirect "/"))


;;
;; Error pages
(defmethod on-exception ((app <web>) code)
  (declare (ignore app))
  #?"ERROR: ${code}"
  ;; (lisp-render (error-page code))
  )
