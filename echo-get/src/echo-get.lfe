;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule echo-get
  ;; API
  (export (start 0)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start ()
  "Ensure all dependencies have been started for the application."
  (application:ensure_all_started 'echo-get))
