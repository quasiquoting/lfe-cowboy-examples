;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule ws-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

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
    (ws-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun priv-dir (app path extra)
  "Since cowboy_static calls code:priv_dir/1 internally and code:priv_dir/1
doesn't like app names in kebab case, use this `#(dir ...)` config instead of:
```{.lfe}
`#(priv_dir ,app ,path ,extra)
```"
  `#(dir ,(++ (priv-dir app) "/" path) ,extra))
