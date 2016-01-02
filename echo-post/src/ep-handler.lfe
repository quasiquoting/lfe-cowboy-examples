;; Feel free to use, reuse and abuse the code in this file.

(defmodule ep-handler
  (export (init 2)))

(defun init (req opts)
  (let* ((method    (cowboy_req:method req))
         (has-body? (cowboy_req:has_body req))
         (reply     (maybe-echo method has-body? req)))
    `#(ok ,reply ,opts)))

(defun maybe-echo
  ([#"POST" 'true req]
   (let* ((`#(ok ,post-vals ,req*) (cowboy_req:body_qs req))
          (echo (proplists:get_value #"echo" post-vals)))
     (echo echo req*)))
  ([#"POST" 'false req]
   (cowboy_req:reply 400 [] #"Missing body." req))
  ([_ _ req]
   ;; Method not allowed.
   (cowboy_req:reply 405 req)))

(defun echo
  (['undefined req]
   (cowboy_req:reply 400 [] #"Missing echo parameter." req))
  ([echo req]
   (cowboy_req:reply 200 `[#(#"content-type" #"text/plain; charset=utf-8")]
                     echo req)))