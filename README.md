
## USAGE

### 1. `cpma-linux.sh`

Provide `pak0.pk3` and `q3config.cfg`:
```bash
$ ls -1 files/
pak0.pk3
q3config.cfg
```

Build and run the game:
```bash
$ ./cpma-linux.sh
```

Or examine the container:
```bash
$ ./cpma-linux.sh /bin/bash
```

**Be sure that your `pulseaudio` deamon has `TCP` support enabled and listens on `PULSE_SERVER="tcp:localhost:4713"`**.

### 2. `cpma-win32.sh`

Provide `pak0.pk3`:
```bash
$ ls -1 files/
pak0.pk3
```

Build the game:
```bash
$ ./cpma-win32.sh
```

Or examine the container:
```bash
$ ./cpma-win32.sh /bin/bash
```

**Grab `.q3a-win32.zip` file from `output/` directory.**

[//]: # ( vim:set ts=4 sw=4 et syn=markdown: )
