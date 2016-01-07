;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule websocket-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1))
  (import (from lone-ranger (priv-dir 2) (priv-file 2))))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((dispatch  (cowboy_router:compile
                      `[#(_ [#("/" cowboy_static
                               ,(priv-file 'websocket "index.html"))
                             #("/websocket" ws-handler [])
                             #("/static/[...]" cowboy_static
                               ,(priv-dir 'websocket "static"))])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])])))
    (websocket-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
