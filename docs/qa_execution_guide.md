# RunPet QA Execution Guide

## 1. Start Backend
```powershell
cd D:\scan_work\RunPet_api_repo
.\scripts\run_dev.ps1
```

## 2. Start App
```powershell
cd D:\scan_work\runpet_app
.\scripts\run_dev.ps1
```

## 3. Execute QA Cases
- Follow `docs/qa_test_cases.md` in order (`TC-APP-001` to `TC-APP-008`).
- Record result for each case:
  - `PASS`
  - `FAIL`
  - `BLOCKED`

## 4. Defect Logging Template
- ID: `BUG-YYYYMMDD-###`
- Title:
- Steps to reproduce:
- Expected:
- Actual:
- Environment (device/os/build):
- Severity: `Critical | High | Medium | Low`

## 5. Regression Gate
- Mandatory pass:
  - App launch
  - Run start/finish
  - Pet equip
  - Purchase verify success/failure handling
- If any mandatory case fails, release is blocked.

