(in-package :webtest.view)

(defmacro layout-template ()
  ``(,,(doctype)
       (html (lang= "en")
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





