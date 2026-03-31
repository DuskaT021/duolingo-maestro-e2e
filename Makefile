# Maestro E2E — run from repo root with an Android emulator or device connected.
# Slow emulators: override with MAESTRO_DRIVER_STARTUP_TIMEOUT=180000 make test-smoke
export MAESTRO_DRIVER_STARTUP_TIMEOUT ?= 120000

MAESTRO ?= maestro
CONFIG ?= maestro/config.yaml

.PHONY: test-smoke test-onboarding test-all test-smoke-reinstall test-subflow

test-smoke:
	$(MAESTRO) test maestro/flows/smoke/ --config $(CONFIG)

test-smoke-reinstall:
	$(MAESTRO) test maestro/flows/smoke/ --config $(CONFIG) --reinstall-driver

test-onboarding:
	$(MAESTRO) test maestro/flows/onboarding/duolingo_onboarding.yaml --config $(CONFIG)

test-all:
	$(MAESTRO) test maestro/flows/ --config $(CONFIG)

test-subflow:
	$(MAESTRO) test $(FLOW) --config $(CONFIG)
