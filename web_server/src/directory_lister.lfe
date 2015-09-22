;; Feel free to use, reuse and abuse the code in this file.

(defmodule directory_lister
  (behaviour cowboy_middleware)
  (export (execute 2)))

(defun execute (req env)
  (let* ((path                                (cowboy_req:path_info req))
         (path*                               (binary:list_to_bin
                                               (lc ((<- s path))
                                                 (binary (s binary) (#"/" binary)))))
         (`#(handler_opts #(,_ ,_ ,_ ,extra)) (lists:keyfind
                                               'handler_opts 1 env))
         (`#(dir_handler ,dir-handler)        (lists:keyfind
                                               'dir_handler 1 extra))
         (full-path                           (resource-path path*)))
    (case (and (valid-path? path) (filelib:is_dir full-path))
      ('true  (handle-directory req env path* full-path dir-handler))
      ('false `#(ok ,req ,env)))))

(defun handle-directory (req env prefix path dir-handler)
  (let ((env* (lists:keydelete 'handler 1
                               (lists:keydelete 'handler_opts 1 env))))
    `#(ok ,req [#(handler ,dir-handler) #(handler_opts #(,prefix ,path)) .
                ,env*])))

(defun valid-path?
  (['()]                 'true)
  ([`(#".." . ,_t)]      'false)
  ([(cons (binary "/" (_ binary)) _t)] 'false)
  ([`(,_h . ,rest)]      (valid-path? rest)))

(defun resource-path (path) (filename:join `[(code:priv_dir web_server) ,path]))
