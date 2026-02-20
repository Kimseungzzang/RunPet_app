# RunPet User Scenarios

## Scope
- App: Flutter client
- API: RunPet backend
- Version baseline: main branch

## Scenario 1: First Launch and Run Start
1. User opens app for first time.
2. App loads pet state from API (`GET /api/v1/pet`).
3. User taps `Start run`.
4. App requests location permission.
5. App starts run session via API (`POST /api/v1/runs/start`).

Expected:
- Run session ID is created.
- Running tab shows live distance/time/pace updates.

## Scenario 2: Finish Run and Pet Growth
1. User has active run.
2. User taps `Finish run`.
3. App sends metrics to API (`POST /api/v1/runs/{runId}/finish`).
4. API calculates EXP/coin and updates pet level.
5. App opens result screen and reloads pet data.

Expected:
- Result screen shows EXP and coin gained.
- Pet level/exp reflects updated state.

## Scenario 3: Pet Equip Flow
1. User opens Pet tab.
2. User taps `Equip sample hat`.
3. App calls API (`POST /api/v1/pet/equip`).
4. App refreshes pet equipment state.

Expected:
- Equipped hat is visible in pet info section.

## Scenario 4: Purchase Flow (IAP + Backend Verify)
1. User opens Shop.
2. App loads store products via in-app purchase SDK.
3. User purchases a product.
4. App receives purchase stream event.
5. App sends receipt/token to API (`POST /api/v1/payments/verify`).

Expected:
- If verified: success snackbar and verified message.
- If not verified: error message with failure reason.

## Scenario 5: API Offline/Error Handling
1. Stop backend server.
2. Start app and trigger run start / pet load / purchase verify.

Expected:
- App shows user-facing error snackbar.
- App remains responsive (no crash).

