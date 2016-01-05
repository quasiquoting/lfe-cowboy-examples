;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule chw-handler
  (export (init 2)))

(defun init (req opts)
  (let ((reply (cowboy_req:chunked_reply 200 req)))
    (cowboy_req:chunk "Hello\r\n" reply)
    (timer:sleep 1000)
    (cowboy_req:chunk "World\r\n" reply)
    (timer:sleep 1000)
    (cowboy_req:chunk "Chunked!\r\n" reply)
    `#(ok ,reply ,opts)))
