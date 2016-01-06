;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule rest-stream-response-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

;; Shout out to Clojure!
(defmacro doto
  "Evaluate all given s-expressions and functions in order,
for their side effects, with the value of `x` as the first argument
and return `x`."
  (`(,x . ,sexps)
   `(let ((,'y ,x))
      ,@(lists:map
          (match-lambda
            ([`(,f . ,args)] `(,f ,'y ,@args))
            ([f]             `(,f ,'y)))
          sexps)
      ,'y)))


;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((table     (doto (ets:new 'stream-tab []) (generate-rows 1000)))
         (dispatch  (cowboy_router:compile
                      `[#(_ [#("/[:v1]" [#(v1 int)] toppage-handler ,table)])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])])))
    (rest-stream-response-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun generate-rows
  ([_table 0] 'ok)
  ([table  n]
   (ets:insert table `#(,(key) ,(val) ,(val)))
   (generate-rows table (- n 1))))

(defun key () (key 10))

(defun key (n) (key (binary ((- (random:uniform 26) 1) integer)) (- n 1)))

(defun key
  ([acc 0] (binary_part (base64:encode acc) 0 8))
  ([acc n]
   (key (binary (acc binary) ((- (random:uniform 26) 1) integer)) (- n 1))))

(defun val () (random:uniform 50))
