;; Feel free to use, reuse and abuse the code in this file.

(defmodule web-server
  (export (start 0)))

(defun start () (application:ensure_all_started 'web-server))
