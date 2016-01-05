;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule echo-get
  (export (start 0)))

(defun start () (application:ensure_all_started 'echo-get))
