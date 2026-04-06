# Mobile E2E Sample — Maestro

![Maestro smoke (Android)](https://github.com/DuskaT021/duolingo-maestro-e2e/actions/workflows/maestro-smoke.yml/badge.svg)

Mobile end-to-end test suite for **Duolingo** (Android, `com.duolingo`) using **Maestro** — YAML-based mobile UI automation. Covers a fast smoke check and a full onboarding journey split into nested flows for readability and reuse.
> [!NOTE]
> CI is expected to fail — the workflow requires a `DUOLINGO_APK_URL` secret with a valid APK download link. Without it the install step is skipped and the job exits early. The flows run successfully on a local device/emulator with Duolingo installed.

---

## What's covered

| Flow | Type | Description |
|------|------|-------------|
| `smoke.yaml` | Smoke | Fast launch assertions — app starts, key elements visible |
| `onboarding.yaml` | Full journey | Complete onboarding split into nested `runFlow` subflows |
| `debug/` | Debug wrappers | Set up required prior state, then run a target subflow standalone |

---

## Tech stack

- [Maestro](https://maestro.mobile.dev/) — YAML-based mobile UI automation
- Android Emulator / physical device via `adb`
- GitHub Actions CI with JUnit + artifact upload

---

## Demo

https://github.com/user-attachments/assets/3fad5ef2-c78c-488b-9522-2f48e036c2ca

---

## Local setup

Full details and run instructions: [maestro/README.md](maestro/README.md)

```bash
# Install Maestro CLI
curl -Ls "https://get.maestro.mobile.dev" | bash

# Run smoke flow
maestro test maestro/flows/smoke.yaml

# Run full onboarding
maestro test maestro/flows/onboarding.yaml
```

> **Requires** Duolingo installed on a connected device or emulator (`adb devices` to verify).

---

## CI behavior

GitHub Actions runs the smoke flow on an Android emulator on every push. JUnit results and test output are uploaded as artifacts.

> **Note:** CI requires a `DUOLINGO_APK_URL` secret (HTTPS link to a Duolingo APK). Without it the install step is skipped and the job exits early. Local runs work with Duolingo already installed on a device/emulator.

---

## Debug flows

`maestro/flows/debug/` contains wrapper flows that set up required prior onboarding state before running a target subflow. Use these when a subflow depends on app state and cannot run standalone.

---

## Known issues

If terminal launch fails with `Unable to launch app` or `localhost:7001`, see [MAESTRO_LAUNCH_ISSUE_NOTE.md](MAESTRO_LAUNCH_ISSUE_NOTE.md) for the fix.
