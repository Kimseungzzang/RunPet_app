# 3D Pet Slot Attach Spec (Option 1)

## Goal
- Use one base pet rig and attach slot assets (`hat`, `outfit`, `background`) at runtime.
- Avoid exporting every combination as separate files.

## Runtime Contract
- Slots:
  - `slot_hat`
  - `slot_outfit`
  - `slot_bg_anchor`
- Item IDs:
  - `hat_leaf_cap`, `hat_sport_band`
  - `outfit_runner_red`, `outfit_runner_blue`
  - `background_park_day`, `background_city_night`

## DCC (Blender) Rules
- Base pet and all wearable assets must use the same unit scale and forward axis.
- Wearable pivot/origin must be aligned to the target slot transform.
- If skinned:
  - Reuse the same armature and bone names as base pet.
  - Weight paint must be normalized.
- Keep mesh names deterministic:
  - `hat_<id>`
  - `outfit_<id>`
  - `bg_<id>`

## Export Rules
- Format: `.glb`
- Include animation clips in base model (`Idle`, `Run`, `Walk`, `Survey` at minimum).
- Optimize:
  - Merge materials where possible
  - Limit textures to power-of-two sizes
  - Use compression pipeline (Draco/KTX2) in build step

## Current App Integration
- 3D mode is enabled by default via `ENABLE_3D_PET`.
- Legacy model URL resolution supports template:
  - `PET_3D_MODEL_TEMPLATE_URL=https://cdn.example.com/pets/pet_{hat}_{outfit}_{bg}.glb`
- Fallback model:
  - `PET_3D_MODEL_URL`
- Runtime-attach mode (web-first):
  - `ENABLE_3D_RUNTIME_ATTACH=true`
  - `PET_3D_BASE_MODEL_URL=https://cdn.example.com/pets/pet_base.glb`
  - `PET_3D_SLOT_MODEL_TEMPLATE_URL=https://cdn.example.com/pets/{slot}_{id}.glb`

If template URL is provided, app resolves placeholders:
- `{hat}` -> equipped hat id or `none`
- `{outfit}` -> equipped outfit id or `none`
- `{bg}` -> equipped background id or `none`

If runtime-attach is enabled, app resolves slot placeholders:
- `{slot}` -> `hat` | `outfit` | `bg`
- `{id}` -> equipped item id

## Next Step for True Runtime Attach
- Harden runtime-attach path:
  - Validate and monitor asset loading failures per slot
  - Add quality fallback when slot node is missing in base model
  - Add regression tests for resolver + runtime mode flags
