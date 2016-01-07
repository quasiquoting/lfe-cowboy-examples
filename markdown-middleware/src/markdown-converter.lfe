;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule markdown-converter
  (behaviour cowboy_middleware)
  ;; Cowboy middleware
  (export (execute 2))
  (import (from lone-ranger (priv-dir 1))))

;;;===================================================================
;;; Cowboy middleware
;;;===================================================================

(defun execute (req env)
  (let ((`[,path] (cowboy_req:path_info req)))
    (case (filename:extension path)
      (#".html" (maybe-generate-markdown (resource-path path)))
      (_ext 'ok)))
  `#(ok ,req ,env))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun maybe-generate-markdown (path)
  (let* ((modified-at (filelib:last_modified (source-path path)))
         (generated-at (filelib:last_modified path)))
    (if (> modified-at generated-at)
      (markdown:conv_file (source-path path) path)
      'ok)))

(defun resource-path (path)
  "Given a relative `path`, return the absolute path from joining the `priv`
directory with `path`."
  (filename:join `[,(priv-dir 'markdown-middleware) ,path]))

(defun source-path (path)
  (binary ((filename:rootname path) binary) ".md"))
