;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule toppage-handler
  (doc "Cookie handler.")
  ;; Cowboy handler
  (export (init 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  (let* ((new-value (integer_to_list (random:uniform 1000000)))
         (req2 (cowboy_req:set_resp_cookie
                 #"server" new-value '[#(path #"/")] req))
         (`#m(client ,client-cookie server ,server-cookie)
          (cowboy_req:match_cookies '[#(client [] #"") #(server [] #"")] req2))
         (`#(ok ,body) (cookie_dtl:render
                         `[#(client ,client-cookie)
                           #(server ,server-cookie)]))
         (req3 (cowboy_req:reply 200
                 '[#(#"content-type" #"text/html")]
                 body req2)))
    `#(ok ,req3 ,opts)))
