%% Feel free to use, reuse and abuse the code in this file.

{application, web_server,
 [{description,  "Cowboy static file handler with directory indexes."},
  {vsn,          "1"},
  {modules, []},
  {registered,   ['ws-sup']},
  {applications, [kernel, stdlib, cowboy, jsx]},
  {mod,          {'ws-app', []}},
  {env,          []}]}.