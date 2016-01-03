(defmodule ws-util
  (export (priv-dir 1)))

(defun priv-dir (app)
  "Given an app name as an atom, return its priv dir.
Call `code:priv_dir/1` or hack together the priv dir manually, using a little
hack that should Just Work™, even if the app name is in kebab case."
  (case (code:priv_dir app)
    (#(error bad_name)
     (let ((app-dir (filename:dirname (filename:dirname (code:which app)))))
       (filename:absname_join app-dir "priv")))
    (priv-dir priv-dir)))
