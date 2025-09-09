{...}:
{

  getenv = name:
    builtins.getEnv "RPINX_${name}";

  getEnvOrFail = name:
    let
      v = builtins.getEnv "RPINX_${name}";
    in if v == "" then
      builtins.throw ( "ERROR: environment variable RPINX_${name} must be set (${v}) (e.g. export RPINX_${name}=...)" )
    else v;
}
