(in-package :webtest.view)
(load "layout")


(defparameter *login-html-content* 
  ``((a (:href "/") "回到首页")
     (a (:href "/register") "注册")
     (hr)
     (div (:class "container")
          (div (:class "col-sm-offset-3  col-sm-6")
               (div (:class "panel panel-default")
                    (div (:class "panel-heading")
                         (h2 (:class "panel-title") "登录"))
                    (div (:class "panel-body")
                         ,(bs-form '(("user" "text" "username" "请输入用户名")
                                     ("lock" "password" "password" "请输入密码"))
                                   '(("submit" "btn btn-primary btn-block" "login" "登录")))))))))

(defparameter *login-js*
  (ps
    ($ (lambda ()
         (chain
          ($ "#login")
          (click
           (lambda ()
             (let ((uname (chain ($ "#username") (val)))
                   (pwd (chain ($ "#password") (val))))
               (var data
                    (create :uname uname
                            :upwd pwd))
               (chain
                $
                (ajax (create
                       url "/login"
                       type "post"
                       data data
                       success (lambda (data status)
                                 (if (= status "success")
                                     (setf (@ location href) "home")))
                       error (lambda (jqXHR textStatus errorThrown)
                               (chain
                                ($ ".panel-title")
                                (text (+ "登录失败 重来" " : " (@ jqXHR response-text))))))))))))))))


(defmacro login-page-mac ()
  `(html-template
    (layout-template)
    ,(merge-args
      *args*
      `(:title
        "Login"
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
        :content ,*login-html-content*
        :scripts
        `(,(getf *web-links* :jq-js)
           ,(getf *web-links* :bs-js)
            (script () ,*login-js*)
           )))))

(defun login-page ()
  (login-page-mac))
