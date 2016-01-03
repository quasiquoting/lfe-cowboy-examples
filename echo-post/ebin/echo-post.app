%% Feel free to use, reuse and abuse the code in this file.

{application,    'echo-post',
 [{description,  "Cowboy POST echo example."},
  {vsn,          "1"},
  {modules,      ['echo-post', 'ep-app', 'ep-handler', 'ep-sup']},
  {registered,   ['ep-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod,          {'ep-app', []}},
  {env,          []}]}.
