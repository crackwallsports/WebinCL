(in-package :webtest.view)
(interpol:enable-interpol-syntax)
(cl-syntax:use-syntax :interpol)  

(defmacro layout-template ()
  ``(,,(doctype)
       (html (:lang "en")
            (head ()
                  (meta (:charset "utf-8"))
                  (meta (:name "viewport"
                               :content "width=device-width, initial-scale=1, shrink-to-fit=no"))
                  (meta (:name "description" :content "?"))
                  (meta (:name "author" :content "Xt3"))
                  (title nil ,title)
                  ,@links
                  ,@head-rest)
            (body () ,@content ,@scripts))))


;; Ref Links
(defparameter *web-links*
  (list
   :main-css '(link (:rel "stylesheet" :href "css/main.css"))
   :main-js '(script (:src "js/main.js"))
   :bs-css '(link (:crossorigin "anonymous"
                   :rel "stylesheet"
                   :integrity "sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u"
                   :href "https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"))
   :jq-js '(script (:src "https://code.jquery.com/jquery-3.2.1.js"
                    :integrity "sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE="
                    :crossorigin "anonymous"))
   :bs-js '(script (:crossorigin "anonymous"
                    :src "https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"
                    :integrity "sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa"))))



;; Bootstrap
(defun bs-form (inputs buttons)
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
         ,@(loop for i in buttons
              collect
                (destructuring-bind (type class id text) i
                  `(div (:class "form-group")
                        (button (:type ,type :id ,id :class ,class) ,text))))))
