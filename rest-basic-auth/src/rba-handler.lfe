;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule rba-handler
  (doc "Handler with basic HTTP authorization.")
  ;; Cowboy handler
  (export (init 2))
  ;; REST callbacks
  (export (content_types_provided 2)
          (is_authorized 2))
  ;; API
  (export (to-text 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Switch to the REST protocol and start executing the state machine."
  `#(cowboy_rest ,req ,opts))


;;;===================================================================
;;; REST callbacks
;;;===================================================================

(defun content_types_provided (req state)
  "TODO: write docstring"
  `#([#(#"text/plain" to-text)]
     ,req ,state))

(defun is_authorized (req state)
  "TODO: write docstring"
  (case (cowboy_req:parse_header #"authorization" req)
    (`#(basic ,user #"open sesame") (when (=:= user #"Aladdin"))
     `#(true ,req ,user))
    (_
     `#(#(false #"Basic realm=\"cowboy\"") ,req ,state))))


;;;===================================================================
;;; API
;;;===================================================================

(defun to-text (req user)
  "TODO: write docstring"
  `#(,(binary "Hello, " (user binary) "!\n") ,req ,user))
