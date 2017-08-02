(in-package :webtest.view)
(load "layout")

(defparameter *register-html-content* 
  ``((a (:href "/") "回到首页")
     (a (:href "/login") "登录")
     (hr)
     (div (:class "container")
          (div (:class "col-sm-offset-3  col-sm-6")
               (div (:class "panel panel-default")
                    (div (:class "panel-heading")
                         (h2 (:class "panel-title") "注册信息"))
                    (div (:class "panel-body")
                         ,(bs-form '(("user" "text" "username" "请输入用户名")
                                     ("lock" "password" "password" "请输入密码")
                                     ("lock" "password" "repassword" "请再次输入密码"))
                                   '(("submit" "btn btn-primary btn-block" "register" "注册")))))))))

(defparameter *register-js*
  (ps
    ($ (lambda ()
         (chain
          ($ "#register")
          (click
           (lambda ()
             (let ((uname (chain ($ "#username") (val)))
                   (pwd (chain ($ "#password") (val)))
                   (repwd (chain ($ "#repassword") (val))))
               (if (/= pwd repwd)
                   (progn
                     (chain
                      ($ "#password")
                      (css "border" "1px solid red"))
                     (chain
                      ($ "#repassword")
                      (css "border" "1px solid red")))
                   (progn
                     (var data
                          (create :uname uname
                                  :upwd pwd))
                     (chain
                      $
                      (ajax (create
                             url "/register"
                             type "post"
                             data data
                             success (lambda (data status)
                                       (if (= status "success")
                                           (setf (@ location href) "login")))
                             error (lambda (data err)
                                     (chain
                                      ($ ".panel-title")
                                      (text "注册失败 重来"))
                                     ;; (setf (@ location href) "register")
                                     ))))))))))))))
  
(defmacro register-page-mac ()
  `(html-template
    (layout-template)
    ,(merge-args
      *args*
      `(:title
        "Register"
        :links
        `(,(getf *web-links* :bs-css)
           ,(getf *web-links* :main-css))
        :head-rest
        `((style
           ()
           ,(->css
             '((".form-horizontal" ()
                (".form-group" (:margin "15px")))
               (".panel-title" (:text-align "center"
                                :font-size "18px"
                                :font-weight "600"))))))
        :content ,*register-html-content*
        :scripts
        `(,(getf *web-links* :jq-js)
           ,(getf *web-links* :bs-js)
           (script () ,*register-js*))))))

(defun register-page ()
  (register-page-mac))
