# RunPet App QA Test Cases

## Test Environment
- Flutter SDK: 3.27.3
- Android emulator or physical device
- API server running in `dev` or `release` mode

## TC-APP-001 App Launch
- Precondition: API server is up.
- Steps:
1. Run app in dev mode.
2. Observe Home screen.
- Expected:
1. App launches without crash.
2. Bottom navigation (`Home`, `Running`, `Pet`, `Report`) is visible.

## TC-APP-002 Run Start
- Precondition: Location permission allowed.
- Steps:
1. Tap `Start run`.
2. Move device/emulator location (or wait for stream).
- Expected:
1. Session starts successfully.
2. Distance/time counters increase.

## TC-APP-003 Run Finish
- Precondition: Active run exists.
- Steps:
1. Tap `Finish run`.
- Expected:
1. Result screen opens.
2. EXP/coin fields are shown.
3. No API error snackbar.

## TC-APP-004 Pet Equip
- Precondition: App launched and pet loaded.
- Steps:
1. Go to Pet tab.
2. Tap `Equip sample hat`.
- Expected:
1. API call succeeds.
2. Hat value updates in pet equipment list.

## TC-APP-005 Shop Product Load
- Precondition: Device supports store and test products are configured.
- Steps:
1. Open Shop.
- Expected:
1. Product list appears with title/price.
2. Non-available products are disabled.

## TC-APP-006 Purchase Verify Success
- Precondition: Test purchase available, backend verification enabled.
- Steps:
1. Purchase one product.
2. Wait for purchase callback.
- Expected:
1. App calls backend verify endpoint.
2. Verified snackbar is shown.

## TC-APP-007 Purchase Verify Failure
- Precondition: Backend configured to fail verification (invalid token path).
- Steps:
1. Trigger purchase callback with invalid receipt/token.
- Expected:
1. App shows `Purchase not verified` or verification failure message.
2. App does not crash.

## TC-APP-008 API Down Handling
- Precondition: API server stopped.
- Steps:
1. Relaunch app.
2. Try loading pet or start run.
- Expected:
1. Error snackbar shown.
2. App remains usable.

