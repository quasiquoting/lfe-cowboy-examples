;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule ws-handler
  (doc "WebSocket handler.")
  ;; Cowboy handler
  (export (init 2))
  ;; cowboy_websocket callbacks
  (export (websocket_handle 3)
          (websocket_info 3)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Switch to the WebSocket protocol and start executing the state machine."
  (erlang:start_timer 1000 (self) #"Hello!")
  `#(cowboy_websocket ,req ,opts))


;;;===================================================================
;;; cowboy_websocket callbacks
;;;===================================================================

(defun websocket_handle
  ([`#(text ,msg) req state]
   `#(reply #(text ,(binary "That's not what I heard! " (msg binary)))
            ,req ,state))
  ([_data req state]
   `#(ok ,req ,state)))

(defun websocket_info
  ([`#(timeout ,_ref ,msg) req state]
   (erlang:start_timer 1000 (self) #"Is there anybody out there?")
   `#(reply #(text ,msg) ,req ,state))
  ([_info req state]
   `#(ok ,req ,state)))
