;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule web-server-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1))
  (import (from lone-ranger (priv-dir 3))))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((extra     '[#(mimetypes   cow_mimetypes all)
                      #(dir_handler directory-handler)])
         (dispatch  (cowboy_router:compile
                      `[#(_ [#("/[...]" cowboy_static
                               ,(priv-dir 'web-server "" extra))])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])
                        #(middlewares
                          [cowboy_router directory-lister cowboy_handler])])))
    (web-server-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
