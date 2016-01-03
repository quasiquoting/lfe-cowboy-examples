%% Feel free to use, reuse and abuse the code in this file.

{application, 'error-hook',
 [{description, "Cowboy error handler example."},
  {vsn, "1"},
  {modules, []},
  {registered, ['eh-sup']},
  {applications, [kernel, stdlib, cowboy]},
  {mod, {'eh-app', []}},
  {env, []}
 ]}.
