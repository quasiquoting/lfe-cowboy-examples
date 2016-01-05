;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule cr-app
  (behaviour application)
  (export (start 2) (stop 1)))

(defun start (_type _args)
  (let* ((dispatch  (cowboy_router:compile '(#(_ (#("/" cr-handler []))))))
         (`#(ok ,_) (cowboy:start_http 'http 100 '(#(port 8080))
                                       `(#(compress true)
                                         #(env (#(dispatch ,dispatch)))))))
    (cr-sup:start_link)))

(defun stop (_state) 'ok)
