;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule toppage-handler
  (doc "Hello world handler")
  ;; Cowboy handler
  (export (init 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  (let ((reply (cowboy_req:reply 200
                 '[#(#"content-type" #"text/plain")]
                 #"Hello world!" req)))
    `#(ok ,reply ,opts)))
