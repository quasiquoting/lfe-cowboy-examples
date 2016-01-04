;; Feel free to use, reuse and abuse the code in this file.

(defmodule rba-handler
  (doc "Handler with basic HTTP authorization.")
  (export (init 2))
  (export (content_types_provided 2)
          (is_authorized 2)
          (to-text 2)))

(defun init (req opts) `#(cowboy_rest ,req ,opts))

(defun content_types_provided (req state)
  `#([#(#"text/plain" to-text)]
     ,req ,state))

(defun is_authorized (req state)
  (case (cowboy_req:parse_header #"authorization" req)
    (`#(basic ,user #"open sesame") (when (=:= user #"Aladdin"))
     `#(true ,req ,user))
    (_
     `#(#(false #"Basic realm=\"cowboy\"") ,req ,state))))

(defun to-text (req user)
  `#(,(binary "Hello, " (user binary) "!\n") ,req ,user))
