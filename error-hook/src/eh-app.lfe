;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule eh-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((dispatch  (cowboy_router:compile '[#(_ [])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])
                        #(onresponse ,(fun error-hook 4))])))
    (eh-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun error-hook
  ([404 headers #"" req]
   (let* ((path     (cowboy_req:path req))
          (body     `["404 Not Found: \"" ,path
                      "\" is not the path you are looking for.\n"])
          (headers2 (lists:keyreplace #"content-length" 1 headers
                                      `#(#"content-length"
                                         ,(integer_to_list
                                           (iolist_size body))))))
     (cowboy_req:reply 404 headers2 body req)))
  ([code headers #"" req] (when (is_integer code) (>= code 400))
   (let* ((body `["HTTP Error " ,(integer_to_list code) 10])
          (headers2 (lists:keyreplace #"content-length" 1 headers
                                      `#(#"content-length"
                                         ,(integer_to_list
                                           (iolist_size body))))))
     (cowboy_req:reply code headers2 body req)))
  ([_code _headers _body req]
   req))
