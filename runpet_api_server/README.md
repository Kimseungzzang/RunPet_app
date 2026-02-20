# RunPet API Server (Spring Boot)

MVP API server for RunPet app.

## Tech
- Spring Boot 3.5.11
- Java 17
- Gradle Wrapper

## Run
On this machine, Java 17 is installed at:
- `C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot`

PowerShell:

```powershell
$env:JAVA_HOME="C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot"
$env:Path="$env:JAVA_HOME\bin;$env:Path"
.\gradlew.bat bootRun
```

Server starts at `http://localhost:8080`.

## API (MVP)

### 1) Start run
`POST /api/v1/runs/start`

```json
{
  "userId": "user_001"
}
```

### 2) Finish run
`POST /api/v1/runs/{runId}/finish`

```json
{
  "distanceKm": 2.14,
  "durationSec": 1122,
  "avgPaceSec": 312,
  "calories": 178
}
```

### 3) Get pet
`GET /api/v1/pet?userId=user_001`

### 4) Equip pet item
`POST /api/v1/pet/equip`

```json
{
  "userId": "user_001",
  "slotType": "hat",
  "itemId": "hat_leaf_cap"
}
```

### 5) Verify payment
`POST /api/v1/payments/verify`

```json
{
  "userId": "user_001",
  "productId": "no_ads_monthly",
  "platform": "android",
  "transactionId": "txn_001",
  "receiptToken": "sample-receipt-token-12345"
}
```

## Notes
- Current storage is in-memory only (for MVP dev).
- Next step: replace with DB + store receipt verification.

