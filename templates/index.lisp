(in-package :webtest.view)
(load "layout")
(interpol:enable-interpol-syntax)
(cl-syntax:use-syntax :interpol)  

(defmacro index-page-mac ()
  `(html-template
    (layout-template)
    ,(merge-args
      *args*
      `(:title "Index"
               :links '()
               :head-rest
               `((style ()
                       ,(->css
                         '(h1 (:color "grey")))))
               :scripts `()
               :content
               `((h1 () ,title)
                 (p () ,#?"欢迎你到 ${title}")
                 (div () 
                      (a (:href "/login") "登录")
                      (a (:href "/register") "注册")))))))

(defun index-page ()
  (index-page-mac))

