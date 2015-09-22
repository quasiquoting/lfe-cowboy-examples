;; Feel free to use, reuse and abuse the code in this file.

(defmodule directory_handler
  (export (init 2)
          (allowed_methods 2) (resource_exists 2) (content_types_provided 2))
  (export (list_json 2) (list_html 2)))

(defun init (req paths) `#(cowboy_rest ,req ,paths))

(defun allowed_methods (req state) `#([#"GET"] ,req ,state))

(defun resource_exists
  ([req `#(,req-path ,file-path)]
   (case (file:list_dir file-path)
     (`#(ok ,fs) `#(true  ,req #(,req-path ,(lists:sort fs))))
     (_err       `#(false ,req #(,req-path ,file-path))))))

(defun content_types_provided (req state)
  `#([#(#(#"application" #"json" []) list_json)
      #(#(#"text"        #"html" []) list_html)]
     ,req ,state))

(defun list_json
  ([req `#(,path ,fs)]
   (let ((files (lists:map #'list_to_binary/1 fs)))
     `#(,(jsx:encode files) ,req ,path))))

(defun list_html
  ([req `#(,path ,fs)]
   (let* ((body `(,(lists:map (lambda (f) (links path f)) `(".." . ,fs))))
          (html `(#b("<!DOCTYPE html><html><head><title>Index</title></head>"
                     "<body>") ,body #"</body></html>\n")))
     `#(,html ,req ,path))))

(defun links
  ([#"" file]    `("<a href='/" ,file "'>" ,file "</a><br>\n"))
  ([prefix file] `("<a href='/" ,prefix #\/ ,file "'>" ,file "</a><br>\n")))
