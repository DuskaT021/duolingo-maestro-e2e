# Maestro workspace

## Prerequisites

- **macOS or Linux** (Windows with WSL2 works with Android tooling; this sample is tested on Unix-style paths).
- **JDK 17+** and **Android SDK** with `adb` on your `PATH`.
- **Android emulator** (API 34 recommended) or a **physical device** with USB debugging; `adb devices` shows `device`.
- **Duolingo** installed on that device/emulator (`com.duolingo`). Install from Play Store or `adb install -r path/to/app.apk`.
- **English UI** — flows assert English copy strings. Other locales will fail until selectors are localized or switched to `id/text` matchers.

## What is covered

| Area | Path | Purpose |
|------|------|--------|
| Smoke | `flows/smoke/app_launch.yaml` | App launches; first screen visible; `stopApp` teardown. |
| Onboarding | `flows/onboarding/duolingo_onboarding.yaml` | Full new-user journey via `runFlow` subflows in `subflows/`. |
| Regression | `flows/regression/` | Placeholder for feature-scoped flows. |

Not covered: API tests, unit tests, iOS (flows use Android resource ids).

**Nested flows:** Files under `subflows/` that are used with `runFlow` must still start with a config section (`appId: com.duolingo` then `---`). Maestro treats every flow file the same way.

**Workspace `config.yaml`:** When using `--config maestro/config.yaml`, Maestro expects **`appId`** or **`url`** in that file. This repo sets `appId: com.duolingo` so CI and local runs validate the same way.

## How to run

### Install Maestro

```bash
curl -Ls "https://get.maestro.mobile.dev" | bash
export PATH="$PATH:$HOME/.maestro/bin"
```

### Run from repo root

```bash
# Smoke (recommended for quick feedback)
make test-smoke
# or
maestro test maestro/flows/smoke/ --config maestro/config.yaml

# Full onboarding (longer)
make test-onboarding

# All flows under maestro/flows/
make test-all

# Single subflow (useful while debugging one segment)
make test-subflow FLOW=maestro/subflows/duo_03_hear_about.yaml

# Debug wrapper flow (includes setup to reach a specific subflow)
maestro test maestro/flows/debug/debug_duo_07_widget_and_outcomes.yaml --config maestro/config.yaml
```

**Flags:** `--config` must be a YAML path (e.g. `maestro/config.yaml`). To reinstall Maestro’s Android driver, use **`--reinstall-driver`** as a separate flag, not as the config value:

```bash
maestro test maestro/flows/onboarding/duolingo_onboarding.yaml \
  --config maestro/config.yaml \
  --reinstall-driver
```

### Reports (optional)

```bash
maestro test maestro/flows/smoke/ \
  --config maestro/config.yaml \
  --format JUNIT \
  --output maestro-report.xml \
  --test-output-dir maestro-output
```

## Lifecycle

- **`launchApp`** must include explicit options (Maestro 2.x): use `clearState: false` for normal runs, or `clearState: true` only when you need a wiped app data directory (slower; on some emulators it can contribute to launch timeouts). A `launchApp:` block with only commented lines is **invalid** and fails with “launchApp requires additional options.”
- Teardown is centralized with **`onFlowComplete`** on top-level flows (`flows/smoke/app_launch.yaml` and `flows/onboarding/duolingo_onboarding.yaml`) and runs `subflows/teardown_stop_app.yaml` so app stop happens once per top-level flow.

## Troubleshooting: `Unable to launch` / `TimeoutException`

If **every** flow fails at `Launch app` (including a minimal flow) and `~/.maestro/tests/.../maestro.log` shows **`java.util.concurrent.TimeoutException`** around **`TcpForwarder`** / **`allocateForwarder`**, the YAML is usually fine; Maestro’s **Android driver** is not completing its **port forward** to the device in time.

Try in order:

1. **Longer driver startup:** `export MAESTRO_DRIVER_STARTUP_TIMEOUT=120000` (milliseconds). The **Makefile** sets this by default for `make test-*`; CI sets `120000` as well.
2. **`adb kill-server && adb start-server`**, then `adb devices` (must show `device`).
3. **`make test-smoke-reinstall`** or **`maestro test maestro/flows/smoke/app_launch.yaml --config maestro/config.yaml --reinstall-driver`**
4. **Cold boot** the AVD (or wipe data once).
5. **Single device:** `maestro test ... --device emulator-5554` (use your serial from `adb devices`).
6. If it still fails: **update Maestro** (`curl -Ls "https://get.maestro.mobile.dev" | bash`) and retry.

If `MAESTRO_DRIVER_STARTUP_TIMEOUT` is already set but logs still show **`TcpForwarder.waitFor`** / **`allocateForwarder`** timing out in a few seconds, that path is **separate** from driver-startup timing; search the [Maestro issue tracker](https://github.com/mobile-dev-inc/maestro/issues) for `TcpForwarder` or attach `maestro.log` from `~/.maestro/tests/...`.

## Known limitations

- **Copy and A/B tests** — Duolingo text can change; prefer stable `id:` selectors when possible.
- **CI APK** — The workflow does not ship the Duolingo APK. Provide a **repository secret** `DUOLINGO_APK_URL` (HTTPS URL to the APK) or place `artifacts/duolingo.apk` locally (gitignored). Without one, the install step fails with a clear message.

## Flake policy

If a step fails:

1. Re-run once; if it fails again, capture Maestro output and screenshots (`--test-output-dir`).
2. Prefer **resource ids** over **exact strings** for high-churn UI.
3. Use **`extendedWaitUntil`** for slow screens if needed.
