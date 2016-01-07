;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule static-world-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1))
  (import (from lone-ranger (priv-file 2) (priv-dir 3))))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application"
  (let* ((dispatch  (cowboy_router:compile
                      `[#(_ [#("/" cowboy_static
                               ,(priv-file 'static-world "index.html"))
                             #("/[...]" cowboy_static
                               ,(priv-dir 'static-world ""
                                  '[#(mimetypes cow_mimetypes all)]))])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])])))
    (static-world-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
