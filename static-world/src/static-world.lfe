;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule static-world
  ;; API
  (export (start 0)))


;;;===================================================================
;;; API
;;;===================================================================

(defun start () (application:ensure_all_started 'static-world))
