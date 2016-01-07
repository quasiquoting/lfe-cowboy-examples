;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule markdown-middleware-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((dispatch  (cowboy_router:compile
                      `[#(_ [#("/[...]" cowboy_static
                               ,(mm-util:priv-dir 'markdown-middleware ""))])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env         [#(dispatch ,dispatch)])
                        #(middlewares [cowboy_router
                                       markdown-converter
                                       cowboy_handler])])))
    (markdown-middleware-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
