%% Feel free to use, reuse and abuse the code in this file.

{application, 'chunked-hello-world',
 [{description,  "Cowboy Chunked Hello World example."},
  {vsn,          "1"},
  {modules, []},
  {registered,   ['chw-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod,          {'chw-app', []}},
  {env,          []}]}.
