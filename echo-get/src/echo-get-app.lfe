;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule echo-get-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((dispatch  (cowboy_router:compile '[#(_ [#("/" toppage-handler [])])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])])))
    (echo-get-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
