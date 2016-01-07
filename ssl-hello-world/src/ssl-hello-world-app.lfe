;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule ssl-hello-world-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1))
  (import (from lone-ranger (priv-dir 1))))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application"
  (let* ((dispatch  (cowboy_router:compile '[#(_ [#("/" toppage-handler [])])]))
         (priv-dir  (priv-dir 'ssl-hello-world))
         (`#(ok ,_) (cowboy:start_https 'https 100
                      `[#(port       8443)
                        #(cacertfile ,(++ priv-dir "/ssl/cowboy-ca.crt"))
                        #(certfile   ,(++ priv-dir "/ssl/server.crt"))
                        #(keyfile    ,(++ priv-dir "/ssl/server.key"))]
                      `[#(env [#(dispatch ,dispatch)])])))
    (ssl-hello-world-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
