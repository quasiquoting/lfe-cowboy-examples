;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule directory-handler
  (doc "Directory handler.")
  ;; REST callbacks
  (export (init 2)
          (allowed_methods 2)
          (resource_exists 2)
          (content_types_provided 2))
  ;; Callback Callbacks
  (export (list-json 2) (list-html 2)))

(defun init (req paths) `#(cowboy_rest ,req ,paths))

(defun allowed_methods (req state) `#([#"GET"] ,req ,state))

(defun resource_exists
  ([req `#(,req-path ,file-path)]
   (case (file:list_dir file-path)
     (`#(ok ,fs) `#(true  ,req #(,req-path ,(lists:sort fs))))
     (_err       `#(false ,req #(,req-path ,file-path))))))

(defun content_types_provided (req state)
  `#([#(#(#"application" #"json" []) list-json)
      #(#(#"text"        #"html" []) list-html)]
     ,req ,state))

(defun list-json
  ([req `#(,path ,fs)]
   (let ((files (lc ((<- f fs)) (list_to_binary f))))
     `#(,(jsx:encode files) ,req ,path))))

(defun list-html
  ([req `#(,path ,fs)]
   (let* ((body (lc ((<- f `(".." . ,fs))) (links path f)))
          (html `(#b("<!DOCTYPE html><html><head><title>Index</title></head>"
                     "<body>") ,body #"</body></html>\n")))
     `#(,html ,req ,path))))

(defun links
  ([#"" file]    `["<a href='/" ,file "'>" ,file "</a><br>\n"])
  ([prefix file] `["<a href='/" ,prefix #\/ ,file "'>" ,file "</a><br>\n"]))
