;; Feel free to use, reuse and abuse the code in this file.

(defmodule ws-app
  (behaviour application)
  (export (start 2) (stop 1)))

(defun start (_type _args)
  (let* ((opts      '[#(mimetypes   cow_mimetypes all)
                      #(dir_handler directory-handler)])
         (dispatch  (cowboy_router:compile
                     `[#(_ [#("/[...]" cowboy_static
                              #(priv_dir web_server "" ,opts))])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                                       `[#(env (#(dispatch ,dispatch)))
                                         #(middlewares (cowboy_router
                                                        directory-lister
                                                        cowboy_handler))])))
    (ws-sup:start_link)))

(defun stop (_state) 'ok)
