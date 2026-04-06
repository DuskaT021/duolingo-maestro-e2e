# Mobile E2E sample - Maestro

This repository showcases **Maestro** end-to-end flows for **Duolingo** (Android, `com.duolingo`): a **smoke** check (fast launch assertions) and a **full onboarding** journey split into **nested flows** (`runFlow`) for readability and reuse.

Details and how to run tests locally are in [maestro/README.md](maestro/README.md). CI runs **smoke** on an Android emulator in GitHub Actions and uploads **JUnit** and **test output** artifacts when configured with an APK.

If terminal launch fails with `Unable to launch app` / `localhost:7001`, see [MAESTRO_LAUNCH_ISSUE_NOTE.md](MAESTRO_LAUNCH_ISSUE_NOTE.md).

## Debug flows

This repo includes `maestro/flows/debug/` wrapper flows that set up required prior onboarding steps, then run a target subflow.  
Use these when a subflow depends on app state and cannot be run standalone.

> **CI note:** The smoke workflow requires a `DUOLINGO_APK_URL` secret (HTTPS link to a Duolingo APK). Without it the install step is skipped and the job exits early. Local runs work with Duolingo installed on a connected device/emulator.

## Tech stack

- [Maestro](https://maestro.mobile.dev/) — YAML-based mobile UI automation
- Android Emulator / physical device with `adb`
- Optional: GitHub Actions + `DUOLINGO_APK_URL` secret or `artifacts/duolingo.apk` for CI

## Demo

<video src="https://github.com/user-attachments/assets/3fad5ef2-c78c-488b-9522-2f48e036c2ca" controls width="100%"></video>

