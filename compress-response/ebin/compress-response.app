%% Feel free to use, reuse and abuse the code in this file.

{application, 'compress-response',
 [{description,  "Cowboy compressed response example."},
  {vsn,          "1"},
  {modules, []},
  {registered,   ['cr-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod,          {'cr-app', []}},
  {env,          []}]}.
