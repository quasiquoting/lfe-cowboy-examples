%% Feel free to use, reuse and abuse the code in this file.

{application,    'ssl-hello-world',
 [{description,  "Cowboy Hello World example with SSL."},
  {vsn,          "1"},
  {modules,      ['ssl-hello-world' ,
                  'ssl-hello-world-sup',
                  'ssl-hello-world-app',
                  'toppage-handler']},
  {registered,   ['ssl-hello-world-sup']},
  {applications, [kernel, stdlib, cowboy, ssl]},
  {mod,          {'ssl-hello-world-app', []}},
  {env,          []}]}.
