package com.runpet.api.dto.pet;

import jakarta.validation.constraints.NotBlank;

public class PetEquipRequest {
    @NotBlank
    private String userId;

    @NotBlank
    private String slotType;

    @NotBlank
    private String itemId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSlotType() {
        return slotType;
    }

    public void setSlotType(String slotType) {
        this.slotType = slotType;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }
}

