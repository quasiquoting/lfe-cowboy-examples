# Hello World Example

## Application Resource File
```{.erlang name="file:src/hello-world.app.src"}
%% Feel free to use, reuse and abuse the code in this file.

{application,    'hello-world',
 [{description,  "Cowboy Hello World example."},
  {vsn,          "1"},
  {modules,      ['hello-world',
                  'hello-world-sup',
                  'hello-world-app',
                  'toppage-handler']},
  {registered,   ['hello-world-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod,          {'hello-world-app', []}},
  {env,          []}]}.
```

## Convenience module
```{.lfe name="file:src/hello-world.lfe"}
;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule hello-world
  ;; API
  (export (start 0)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start ()
  "Ensure all dependencies have been started for the application."
  (application:ensure_all_started 'hello-world))
```

## Supervisor
```{.lfe name="file:src/hello-world-sup.lfe"}
;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule hello-world-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0))
  ;; Supervisor
  (export (init 1)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start_link ()
  "Create a supervisor process as part of a supervision tree."
  (supervisor:start_link `#(local ,(MODULE)) (MODULE) []))


;;;===================================================================
;;; Supervisor
;;;===================================================================

(defun init
  "Return the supervisor flags and child specifications."
  (['()]
   (let ((children []))
     `#(ok #(,(map 'strategy  'one_for_one
                   'intensity 10
                   'period    10)
             ,children)))))
```

## Application
```{lfe name="file:src/hello-world-app.lfe"}
;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule hello-world-app
  (behaviour application)
  ;; API
  (export (start 2) (stop 1)))

;;;===================================================================
;;; API
;;;===================================================================

(defun start (_type _args)
  "Start the application."
  (let* ((dispatch  (cowboy_router:compile '[#(_ [#("/" toppage-handler [])])]))
         (`#(ok ,_) (cowboy:start_http 'http 100 '[#(port 8080)]
                      `[#(env [#(dispatch ,dispatch)])])))
    (hello-world-sup:start_link)))

(defun stop (_state)
  "Stop the application."
  'ok)
```

## Top page handler
```{.lfe name="file:src/toppage-handler.lfe"}
;;;; Feel free to use, reuse and abuse the code in this file.

(defmodule toppage-handler
  (doc "Hello world handler.")
  ;; Cowboy handler
  (export (init 2)))

;;;===================================================================
;;; Cowboy handler
;;;===================================================================

(defun init (req opts)
  "Given a `req`uest and some `opts`, send `Hello world!` as a reply."
  (let ((reply (cowboy_req:reply 200
                 '[#(#"content-type" #"text/plain")]
                 #"Hello world!" req)))
    `#(ok ,reply ,opts)))
```

## relx.config
```{.erlang name="file:relx.config"}
{release, {'hello-world-example', "1"}, ['hello-world']}.
{extended_start_script, true}.
```

## Makefile
```{.make name="file:Makefile"}
PROJECT     = $(notdir $(CURDIR))
DEPS        = lfe cowboy
BUILD_DEPS  = lfe.mk
DEP_PLUGINS = lfe.mk
dep_lfe.mk  = git https://github.com/ninenines/lfe.mk master
dep_cowboy  = git https://github.com/ninenines/cowboy master
include ../resources/make/erlang.mk
include ../resources/make/dev.mk
```
