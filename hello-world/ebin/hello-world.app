%% Feel free to use, reuse and abuse the code in this file.

{application, 'hello-world',
 [{description,  "Cowboy Hello World example."},
  {vsn,          "1"},
  {modules, []},
  {registered,   ['hw-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod,          {'hw-app', []}},
  {env,          []}]}.