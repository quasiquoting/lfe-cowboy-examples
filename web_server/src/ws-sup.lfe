;; Feel free to use, reuse and abuse the code in this file.

(defmodule ws-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0))
  ;; supervisor
  (export (init 1)))

(defun start_link () (supervisor:start_link `#(local ,(MODULE)) (MODULE) '()))

(defun init (['()] '#(ok #(#(one_for_one 10 10) ()))))
