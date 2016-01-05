;; Feel free to use, reuse and abuse the code in this file.

(defmodule ssl-hello-world-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

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


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun priv-dir (app)
  "Given an `app` name as an atom, return the path to its priv directory.
Call `code:priv_dir/1` and return the result, unless it is `#(error bad_name)`.
In that case, hack together the path manually, using a trick that
should Just Work™, even if `app` is in kebab case."
  (case (code:priv_dir app)
    (#(error bad_name)
     (let ((app-dir (filename:dirname (filename:dirname (code:which app)))))
       (filename:absname_join app-dir "priv")))
    (priv-dir priv-dir)))
