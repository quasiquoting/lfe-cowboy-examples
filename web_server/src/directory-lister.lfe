;; Feel free to use, reuse and abuse the code in this file.

(defmodule directory-lister
  (behaviour cowboy_middleware)
  (export (execute 2)))

(defun execute (req env)
  (case (lists:keyfind 'handler 1 env)
    (#(handler cowboy_static) (redirect-directory req env))
    (_h `#(ok ,req ,env))))

(defun redirect-directory (req env)
  (let* ((path  (cowboy_req:path_info req))
         (path* (lists:foldl
                  (lambda (s acc) (binary (acc binary) (s binary) #\/))
                  #"" path))
         (`#(handler_opts #(,_ ,_ ,_ ,extra))
          (lists:keyfind 'handler_opts 1 env))
         (`#(dir_handler ,dir-handler) (lists:keyfind 'dir_handler 1 extra))
         (full-path (resource-path path*)))
    (if (and (valid-path? path) (filelib:is_dir full-path))
      (handle-directory req env path* full-path dir-handler)
      `#(ok ,req ,env))))

(defun handle-directory (req env prefix path dir-handler)
  (let ((env* (lists:keydelete 'handler 1
                (lists:keydelete 'handler_opts 1 env))))
    `#(ok ,req [#(handler ,dir-handler) #(handler_opts #(,prefix ,path)) .
                ,env*])))

(defun valid-path?
  (['()]                 'true)
  ([`(#".." . ,_t)]      'false)
  ([`(,(binary "/" (_ binary)) ,_t)] 'false)
  ([`(,_h . ,rest)]      (valid-path? rest)))

(defun resource-path (path)
  (filename:join `[,(code:priv_dir 'web_server) ,path]))
