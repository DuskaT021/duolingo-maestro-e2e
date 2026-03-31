# Mobile E2E sample — Maestro

This repository showcases **Maestro** end-to-end flows for **Duolingo** (Android, `com.duolingo`): a **smoke** check (fast launch assertions) and a **full onboarding** journey split into **nested flows** (`runFlow`) for readability and reuse.

Details and how to run tests locally are in [maestro/README.md](maestro/README.md). CI runs **smoke** on an Android emulator in GitHub Actions and uploads **JUnit** and **test output** artifacts when configured with an APK.

If terminal launch fails with `Unable to launch app` / `localhost:7001`, see [MAESTRO_LAUNCH_ISSUE_NOTE.md](MAESTRO_LAUNCH_ISSUE_NOTE.md).

## Debug flows

This repo includes `maestro/flows/debug/` wrapper flows that set up required prior onboarding steps, then run a target subflow.  
Use these when a subflow depends on app state and cannot be run standalone.

## Tech stack

- [Maestro](https://maestro.mobile.dev/) — YAML-based mobile UI automation
- Android Emulator / physical device with `adb`
- Optional: GitHub Actions + `DUOLINGO_APK_URL` secret or `artifacts/duolingo.apk` for CI
