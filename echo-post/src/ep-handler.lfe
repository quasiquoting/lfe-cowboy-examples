;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule ep-handler
  (doc "Echo POST handler.")
  ;; Cowboy handler
  (export (init 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Given a `POST` `req`uest and some `opts`, reply back with the value of an
`#\"echo\"` query parameter, if present, otherwise 4xx."
  (let* ((method    (cowboy_req:method req))
         (has-body? (cowboy_req:has_body req))
         (reply     (maybe-echo method has-body? req)))
    `#(ok ,reply ,opts)))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun maybe-echo
  "Given a `method`, `has-body?` and `req`, maybe call [[echo/2]].
If `method` is `#\"POST\"` and `has-body?` is `true`, call [[echo/2]].
Or if `method` is `#\"POST\"` but `has-body?` is `false`, send a `400` reply.
Otherwise, send a `405 Method Not Allowed` reply."
  ([#"POST" 'true req]
   (let* ((`#(ok ,post-vals ,req*) (cowboy_req:body_qs req))
          (echo (proplists:get_value #"echo" post-vals)))
     (echo echo req*)))
  ([#"POST" 'false req]
   (cowboy_req:reply 400 [] #"Missing body." req))
  ([_method _has-body? req]
   ;; Method Not Allowed.
   (cowboy_req:reply 405 req)))

(defun echo
  "Given a string `echo`, send a plain text reply with `echo` as the body."
  (['undefined req]
   (cowboy_req:reply 400 [] #"Missing echo parameter." req))
  ([echo req]
   (cowboy_req:reply 200
     `[#(#"content-type" #"text/plain; charset=utf-8")]
     echo req)))
