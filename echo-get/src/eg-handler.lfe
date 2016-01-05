;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule eg-handler
  (export (init 2)))

(defun init (req opts)
  (let* ((method          (cowboy_req:method req))
         (`#m(echo ,echo) (cowboy_req:match_qs '[#(echo [] undefined)] req))
         (reply           (echo method echo req)))
    `#(ok ,reply ,opts)))

(defun echo
  ([#"GET" 'undefined req]
   (cowboy_req:reply 400 '[] #"Missing echo parameter." req))
  ([#"GET" echo req]
   (cowboy_req:reply 200 '[#(#"content-type" #"text/plain; charset=utf-8")] echo req))
  ([_ _ req]
   (cowboy_req:reply 405 req)))
