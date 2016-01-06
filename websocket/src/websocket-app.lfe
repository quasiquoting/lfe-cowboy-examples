;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule websocket-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

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


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun priv-file (app path)
  "Since cowboy_static calls code:priv_dir/1 internally and code:priv_dir/1
doesn't like app names in kebab case, use this `#(file ...)` config instead of:
```{.lfe}
`#(priv_file web-server \"\" [])
```"
  `#(file ,(filename:absname (++ (priv-dir app) "/" path)) []))

(defun priv-dir (app path)
  "Equivalient to [[priv-dir/3]] with `[]` as `extra`."
  (priv-dir app path []))

(defun priv-dir (app path extra)
  "Since cowboy_static calls code:priv_dir/1 internally and code:priv_dir/1
doesn't like app names in kebab case, use this `#(dir ...)` config instead of:
```{.lfe}
`#(priv_dir ,app ,path ,extra)
```"
  `#(dir ,(filename:join (priv-dir app) path) ,extra))

(defun priv-dir (app)
  "Given an `app` name as an atom, return the path to its `priv` directory.
Call `code:priv_dir/1` and return the result, unless it is `#(error bad_name)`.
In that case, hack together the path manually, using a trick that
should Just Work™, even if `app` is in kebab case."
  (case (code:priv_dir app)
    (#(error bad_name)
     (let ((app-dir (filename:dirname (filename:dirname (code:which app)))))
       (filename:absname_join app-dir "priv")))
    (priv-dir priv-dir)))
