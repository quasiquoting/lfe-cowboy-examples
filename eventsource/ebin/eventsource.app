%% Feel free to use, reuse and abuse the code in this file.

{application, eventsource,
 [{description, "Cowboy EventSource example."},
  {vsn, "1"},
  {modules, []},
  {registered, ['es-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod, {'es-app', []}},
  {env, []}
 ]}.
