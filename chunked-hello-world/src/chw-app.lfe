;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule chw-app
  (behaviour application)
  (export (start 2) (stop 1)))

(defun start (_type _args)
  (let* ((dispatch  (cowboy_router:compile '(#(_ (#("/" chw-handler ()))))))
         (`#(ok ,_) (cowboy:start_http 'http 100 '(#(port 8080))
                                       `(#(env (#(dispatch ,dispatch)))))))
    (chw-sup:start_link)))

(defun stop (_state) 'ok)
