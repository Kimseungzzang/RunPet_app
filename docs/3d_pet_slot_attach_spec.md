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
- Model URL resolution supports template:
  - `PET_3D_MODEL_TEMPLATE_URL=https://cdn.example.com/pets/pet_{hat}_{outfit}_{bg}.glb`
- Fallback model:
  - `PET_3D_MODEL_URL`

If template URL is provided, app resolves placeholders:
- `{hat}` -> equipped hat id or `none`
- `{outfit}` -> equipped outfit id or `none`
- `{bg}` -> equipped background id or `none`

## Next Step for True Runtime Attach
- Replace template-based model swap with scene-graph attach:
  - Load base model once
  - Attach slot mesh by `slot_*` nodes
  - Toggle visibility/remove previous slot mesh
  - Keep animation state machine on base rig
