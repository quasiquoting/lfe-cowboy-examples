;; Feel free to use, reuse and abuse the code in this file.

(defmodule rest-basic-auth
  (export (start 0)))

(defun start () (application:ensure_all_started 'rest-basic-auth))
