(defmodule ws-util
  (export (priv-dir 1)))

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
