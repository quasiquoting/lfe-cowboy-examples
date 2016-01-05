;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule eg-app
  (behaviour application)
  (export (start 2) (stop 1)))

(defun start (_type _args)
  (let* ((dispatch  (cowboy_router:compile '(#(_ (#("/" eg-handler []))))))
         (`#(ok ,_) (cowboy:start_http 'http 100 '(#(port 8080))
                                       `(#(env (#(dispatch ,dispatch)))))))
    (eg-sup:start_link)))

(defun stop (_state) 'ok)
