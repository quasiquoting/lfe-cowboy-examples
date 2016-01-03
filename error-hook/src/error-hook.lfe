;; Feel free to use, reuse and abuse the code in this file.

(defmodule error-hook
  (export (start 0)))

(defun start () (application:ensure_all_started 'error-hook))
