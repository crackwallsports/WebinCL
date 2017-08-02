(in-package :webtest.view)
(load "layout")
(interpol:enable-interpol-syntax)
(cl-syntax:use-syntax :interpol)  

(defparameter *home-html-content* 
  ``((a (:href "/home") "主页")
     (a (:href "/logout") "注销")
     (hr)
     (h1 () ,#?"Name: ${user}")
     (p () "这是你的主页")))

(defmacro home-page-mac ()
  `(html-template
    (layout-template)
    ,(merge-args
      *args*
      `(:title
        "Home"
        :links
        `()
        :head-rest
        `()
        :user "无名氏"
        :content ,*home-html-content*
        :scripts
        `()))))

(defun home-page ()
  (home-page-mac))
