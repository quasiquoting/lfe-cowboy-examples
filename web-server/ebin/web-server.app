%% Feel free to use, reuse and abuse the code in this file.

{application,    'web-server',
 [{description,  "Cowboy static file handler with directory indexes."},
  {vsn,          "1"},
  {modules,      ['directory-handler',
                  'directory-lister',
                  'web-server',
                  'ws-app',
                  'ws-sup',
                  'ws-util']},
  {registered,   ['ws-sup']},
  {applications, [kernel, stdlib, cowboy, jsx]},
  {mod,          {'ws-app', []}},
  {env,          []}]}.
