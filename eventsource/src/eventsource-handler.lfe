;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule eventsource-handler
  (doc "EventSource emitter.")
  ;; Cowboy handler
  (export (init 2) (info 3)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  (let* ((headers '[#("content-type" #"text/event-stream")])
         (req2 (cowboy_req:chunked_reply 200 headers req)))
    (erlang:send_after 1000 (self) #(message "Tick"))
    `#(cowboy_loop ,req2 ,opts 5000)))

(defun info
  ([`#(message ,msg) req state]
   (cowboy_req:chunk `["id: " ,(id) "\ndata: " ,msg "\n\n"] req)
   (erlang:send_after 1000 (self) #(message "Tick"))
   `#(ok ,req ,state)))

;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun id ()
  "Generate and return a pseudorandom identifier (integer)."
  (integer_to_list (erlang:unique_integer '[positive monotonic]) 16))
