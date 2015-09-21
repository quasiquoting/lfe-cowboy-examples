;; Feel free to use, reuse and abuse the code in this file.

(defmodule hello-world
  (export (start 0)))

(defun start () (application:ensure_all_started 'hello-world))
