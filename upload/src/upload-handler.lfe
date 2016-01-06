;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule upload-handler
  (doc "Upload handler.")
  ;; Cowboy handler
  (export (init 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Handle a file upload."
  (let* ((`#(ok ,headers ,req2) (cowboy_req:part req))
         (`#(ok ,data ,req3)    (cowboy_req:part_body req2))
         (`#(file #"inputfile" ,filename ,content-type ,_transfer-encoding)
          (cow_multipart:form_data headers)))
    (io:format "Received file ~p of content-type ~p as follows:~n~p~n~n"
               `[,filename ,content-type ,data])
    `#(ok ,req3 ,opts)))
