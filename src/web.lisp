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
  ;; (render #P"index.html")
  (lisp-render "index" '(:title "主页")))

;; GET /login
(defroute "/login" ()
  (lisp-render "login" '(:title "登录")))

;; GET /register
(defroute "/register" ()
  (lisp-render "register" '(:title "注册")))

;; GET /home
(defroute "/home" ()
  ;; if req.session.user
  (lisp-render "home" '(:title "用户XXX"))
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
  "error"
  ;; (lisp-render (error-page code))
  )
