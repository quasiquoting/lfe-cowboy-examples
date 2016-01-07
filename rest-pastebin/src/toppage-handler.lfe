;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule toppage-handler
  (doc "Pastebin handler.")
  ;; Cowboy handler
  (export (init 2))
  ;; REST callbacks
  (export (allowed_methods 2)
          (content_types_provided 2)
          (content_types_accepted 2)
          (resource_exists 2))
  ;; API
  (export (create-paste 2)
          (paste-html 2)
          (paste-text 2))
  (import (from lone-ranger (priv-dir 1))))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Switch to the REST protocol and start executing the state machine."
  (random:seed (erlang:timestamp))
  `#(cowboy_rest ,req ,opts))


;;;===================================================================
;;; REST callbacks
;;;===================================================================

(defun allowed_methods (req state)
  `#([#"GET" #"POST"] ,req ,state))

(defun content_types_provided (req state)
  `#([#(#(#"text" #"plain" []) paste-text)
      #(#(#"text" #"html"  []) paste-html)]
     ,req ,state))

(defun content_types_accepted (req state)
  `#([#(#(#"application" #"x-www-form-urlencoded" []) create-paste)]
     ,req ,state))

(defun resource_exists (req _state)
  (case (cowboy_req:binding 'paste-id req)
    ('undefined `#(true ,req index))
    (paste-id
     (if (and (valid-path? paste-id) (file-exists? paste-id))
       `#(true ,req ,paste-id)
       `#(false ,req ,paste-id)))))

;;;===================================================================
;;; API
;;;===================================================================

(defun create-paste (req state)
  (let* ((paste-id (new-paste-id))
         (`#(ok [#(#"paste" ,paste)] ,req2) (cowboy_req:body_qs req))
         ('ok (file:write_file (full-path paste-id) paste)))
    (case (cowboy_req:method req2)
      (#"POST" `#(#(true ,(binary #\/ (paste-id binary))) ,req2 ,state))
      (_       `#(true ,req2 ,state)))))

(defun paste-html
  ([req 'index]
   `#(,(read-file "index.html") ,req index))
  ([req paste]
   (let ((`#m(lang ,lang) (match-lang req)))
     `#(,(format-html paste lang) ,req ,paste))))

(defun paste-text
  ([req 'index]
   `#(,(read-file "index.txt") ,req index))
  ([req paste]
   (let ((`#m(lang ,lang) (match-lang req)))
     `#(,(format-text paste lang) ,req ,paste))))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun match-lang (req)
  "Parse a Cowboy request's query string for `lang` and return a map.
Default to `#\"text\" when no highlight `lang` is found, otherwise
`cowboy_req:match_qs/2` will crash undesirably."
  (match-lang #"text" req))

(defun match-lang
  "Given a default and a request, return a map.
See: [[match-lang/1]]"
  ([default req] (when (is_binary default))
   (cowboy_req:match_qs `[#(lang [] ,default)] req))
  ([default req] (when (is_list default))
   (match-lang (list_to_binary default) req)))

(defun read-file (name)
  (let ((`#(ok ,binary) (file:read_file (full-path name))))
    binary))

(defun full-path (name)
  (filename:join `[,(priv-dir 'rest-pastebin) ,name]))

(defun file-exists? (name)
  (case (file:read_file_info (full-path name))
    (`#(ok ,_info)      'true)
    (`#(error ,_reason) 'false)))

(defun valid-path?
  ([#""]                        'true)
  ([(binary #\.   (_t binary))] 'false)
  ([(binary #\/   (_t binary))] 'false)
  ([(binary _char (t binary))]  (valid-path? t)))

(defun new-paste-id ()
  (let ((initial (- (random:uniform 62) 1)))
    (new-paste-id (binary initial) 7)))

(defun new-paste-id
  ([bin 0]
   (let ((chars
          #"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"))
     (bc ((<= b bin))
       ((binary_part chars b 1) binary))))
  ([bin rem]
   (let ((next (- (random:uniform 62) 1)))
     (new-paste-id (binary (bin binary) next) (- rem 1)))))

(defun format-html
  ([paste 'plain]
   (let ((text (escape-html-chars (read-file paste))))
     (binary "<!DOCTYPE html><html>"
             "<head><title>paste</title></head>"
             "<body><pre><code>"
             (text binary)
             "</code</pre></body></html>\n")))
  ([paste lang]
   (highlight (full-path paste) lang "html")))

(defun format-text
  ([paste 'plain] (read-file paste))
  ([paste lang]   (highlight (full-path paste) lang "ansi")))

(defun highlight (path lang type)
  (let* ((path1 (binary_to_list path))
         (lang1 (binary_to_list lang)))
    (os:cmd `["highlight --syntax=" ,lang1
              " --doc-title=paste "
              " --out-format="      ,type
              " --include-style "   ,path1])))

(defun escape-html-chars (bin)
  (bc ((<= b bin))
    ((escape-html-char b) binary)))

(defun escape-html-char
  ([#\<] #"&lt;")
  ([#\>] #"&gt;")
  ([#\&] #"&amp;")
  ([c]   (binary c)))
