package com.runpet.api.model;

public class PetState {
    private final String userId;
    private int petLevel;
    private int petExp;
    private String petMood;
    private String equippedHatId;
    private String equippedOutfitId;
    private String equippedBgId;

    public PetState(String userId) {
        this.userId = userId;
        this.petLevel = 1;
        this.petExp = 0;
        this.petMood = "happy";
    }

    public String getUserId() {
        return userId;
    }

    public int getPetLevel() {
        return petLevel;
    }

    public int getPetExp() {
        return petExp;
    }

    public String getPetMood() {
        return petMood;
    }

    public String getEquippedHatId() {
        return equippedHatId;
    }

    public String getEquippedOutfitId() {
        return equippedOutfitId;
    }

    public String getEquippedBgId() {
        return equippedBgId;
    }

    public void addExp(int earnedExp) {
        this.petExp += earnedExp;
        while (this.petExp >= 100) {
            this.petExp -= 100;
            this.petLevel += 1;
        }
    }

    public void equip(String slotType, String itemId) {
        if ("hat".equalsIgnoreCase(slotType)) {
            equippedHatId = itemId;
        } else if ("outfit".equalsIgnoreCase(slotType)) {
            equippedOutfitId = itemId;
        } else if ("background".equalsIgnoreCase(slotType)) {
            equippedBgId = itemId;
        } else {
            throw new IllegalArgumentException("Unsupported slotType: " + slotType);
        }
    }
}

