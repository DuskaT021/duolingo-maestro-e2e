# Maestro Launch Issue (Solved)

## What failed

- `maestro test ...` from terminal failed immediately with:
  - `Unable to launch app com.duolingo`
  - `io.grpc.StatusRuntimeException: UNAVAILABLE: io exception`
  - `Connection refused: localhost:7001`

## Why it failed

The flow YAML was valid.  
The failure was a local Maestro CLI runtime/driver channel issue (gRPC transport to the Android driver on localhost port `7001`), not test logic.

## How it was resolved

Run these commands in order:

```bash
# 1) Stop stale Maestro processes (safe no-op if none)
pkill -f maestro || true

# 2) Reset adb
adb kill-server
adb start-server

# 3) Remove old Maestro driver apps from emulator
adb -s emulator-5554 uninstall dev.mobile.maestro || true
adb -s emulator-5554 uninstall dev.mobile.maestro.test || true

# 4) Re-run smoke with explicit device + reinstall driver
cd /Users/dusanat/Documents/new-workspace
maestro test maestro/flows/smoke/app_launch.yaml --device emulator-5554 --reinstall-driver
```

If needed, cold boot the emulator once and run step 4 again.

## Useful run commands (project)

```bash
cd /Users/dusanat/Documents/new-workspace

make test-smoke
make test-smoke-reinstall
make test-onboarding
make test-all
```

