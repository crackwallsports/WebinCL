(in-package :webtest.view)
(load "layout")
(interpol:enable-interpol-syntax)
(cl-syntax:use-syntax :interpol)  


(defun bs-form (inputs button)
  `(form (:class "form-horizontal" :role "form" :method "post" :onsubmit "return false")
         ;; (icon type id placeholder)
         ,@(loop for i in inputs
              collect
                (destructuring-bind (icon type id ph) i
                  `(div (:class "form-group")
                        (div (:class "input-group")
                             (div (:class "input-group-addon")
                                  (span (:class ,#?"glyphicon glyphicon-${icon}")))
                             (input (:class "form-control"
                                            :type ,type
                                            :id ,id
                                            :name ,id
                                            :placeholder ,ph
                                            :required "required"))))))
         (div (:class "form-group")
              ,(destructuring-bind (class id text) button
                 `(button (:type "submit" :id ,id :class ,class) ,text)))))

(defparameter *register-html-content* 
  ``((a (:href "/") "回到主页")
     (a (:href "/login") "登录")
     (div (:class "container")
          (div (:class "col-sm-offset-3  col-sm-6")
               (div (:class "panel panel-default")
                    (div (:class "panel-heading")
                         (h2 (:class "panel-title") "注册信息"))
                    (div (:class "panel-body")
                         ,(bs-form '(("user" "text" "username" "请输入用户名")
                                     ("lock" "password" "password" "请输入密码")
                                     ("lock" "password" "repassword" "请再次输入密码"))
                                   '("btn btn-primary btn-block" "register" "注册"))))))))

(defparameter *register-js*
  (ps
    ($ (lambda ()
         (chain
          ($ "#register")
          (click
           (lambda ()
             (let ((username (chain ($ "#username") (val)))
                   (password (chain ($ "#password") (val)))
                   (password1 (chain ($ "#repassword") (val))))
               (if (/= password password1)
                   (progn
                     (chain
                      ($ "#password")
                      (css "border" "1px solid red"))
                     (chain
                      ($ "#repassword")
                      (css "border" "1px solid red")))
                   (progn
                     (var data
                          (create :uname username
                                  :upwd password))
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
        "Index"
        :links `(,(getf *web-links* :bs-css)
                  ,(getf *web-links* :main-css))
        :head-rest `((style
                      ()
                      ,(->css
                        '((".form-horizontal .form-group" (:margin "15px"))
                          (".panel-title" (:text-align "center"
                                  :font-size "18px"
                                  :font-weight "600"))))))
        :content ,*register-html-content*
        :scripts `(,(getf *web-links* :jq-js)
                    ,(getf *web-links* :bs-js)
                    (script () ,*register-js*))))))

(defun register-page ()
  (register-page-mac))
