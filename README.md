how to debug values after build, or just use builtins.trace
```bash
nix-repl .
:lf .
outputs.nixosConfigurations.rpi.config.networking.wireless
:q
```
