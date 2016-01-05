;; Feel free to use, reuse and abuse the code in this file.

(defmodule ssl-hello-world-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0))
  ;; Supervisor
  (export (init 1)))


;;;===================================================================
;;; API
;;;===================================================================

(defun start_link () (supervisor:start_link `#(local ,(MODULE)) (MODULE) '[]))


;;;===================================================================
;;; Supervisor
;;;===================================================================

(defun init
  (['()]
   '#(ok #(#m(strategy  one_for_one
              intensity 10
              period    10)
           []))))
