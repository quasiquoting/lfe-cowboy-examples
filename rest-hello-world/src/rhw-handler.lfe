;; Feel free to use, reuse and abuse the code in this file.

(defmodule rhw-handler
  (export (init 2))
  (export (content_types_provided 2)
          (hello-to-html 2)
          (hello-to-json 2)
          (hello-to-text 2)))

(defun init (req opts) `#(cowboy_rest ,req ,opts))

(defun content_types_provided (req state)
  `#((#(#"text/html"        hello-to-html)
      #(#"application/json" hello-to-json)
      #(#"text/plain"       hello-to-text))
     ,req ,state))

(defun hello-to-html (req state)
  (let ((body #"<html>
<head>
  <meta charset=\"utf-8\">
  <title>REST Hello world!</title>
</head>
<body>
  <p>REST Hello world as HTML!</p>
</body>
</html>"))
    `#(,body ,req ,state)))

(defun hello-to-json (req state)
  (let ((body #"{\"rest\": \"Hello World!\"}"))
    `#(,body ,req ,state)))

(defun hello-to-text (req state) `#(#"REST Hello World as text!" ,req ,state))
