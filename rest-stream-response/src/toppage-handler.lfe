;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule toppage-handler
  (doc "Streaming handler.")
  ;; Cowboy handler
  (export (init 2))
  ;; REST callbacks
  (export (content_types_provided 2))
  ;; API
  (export (streaming-csv 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req table)
  "Switch to the REST protocol and start executing the state machine."
  `#(cowboy_rest ,req ,table))


;;;===================================================================
;;; REST callbacks
;;;===================================================================

(defun content_types_provided (req state)
  "TODO: write docstring"
  `#([#(#(#"text" #"csv" []) streaming-csv)]
     ,req ,state))


;;;===================================================================
;;; API
;;;===================================================================

(defun streaming-csv (req table)
  "TODO: write docstring"
  (let* ((n  (cowboy_req:binding 'v1 req 1))
         (ms `[#(#($1 $2 $3) [#(== $2 ,n)] [$$])]))
    `#(#(stream ,(result-streamer table ms)) ,req ,table)))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun result-streamer (table ms)
  (lambda (socket transport)
    (send-records socket transport (ets:select table ms 1))))

(defun send-records
  ([socket transport `#([,rec] ,cont)]
   (timer:sleep 500)
   (send-line socket transport rec)
   (send-records socket transport (ets:select cont)))
  ([_socket _transport '$end_of_table]
   'ok))

(defun send-line
  ([socket transport `[,key ,v1 ,v2]]
   (call transport 'send socket
         ;; 13 => \r; 10 => \n
         `[,key #\, ,(integer_to_list v1) #\, ,(integer_to_list v2) 13 10])))
