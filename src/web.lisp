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
  (redirect "/")
  ;; (lisp-render "login" '(:title "登录"))
  )

;; GET /register
(defroute "/register" ()
  (lisp-render "register" '(:title "注册")))
;; POST /register
(defroute ("/register" :method :POST) (&key |uname| |upwd|)
  (if (and (equal |uname| "me")
           (equal |upwd| "pwd"))
      (progn (gethash :error *session* "成功")
             (setf (response-status *response*) 200)
             "")
      (progn (gethash :error *session* "失败")
             (setf (response-status *response*) 500)
             "")))

;; GET /home
(defroute "/home" ()
  ;; if req.session.user
  (lisp-render "home" '(:title "主页"))
  ;; else -> /login
  )

;; GET /logout
(defroute "/logout" ()
  ;; -> /
  )


;;
;; Error pages
(defmethod on-exception ((app <web>) code)
  (declare (ignore app))
  #?"ERROR: ${code}"
  ;; (lisp-render (error-page code))
  )
