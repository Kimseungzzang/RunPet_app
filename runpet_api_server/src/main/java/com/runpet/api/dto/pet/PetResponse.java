package com.runpet.api.dto.pet;

public record PetResponse(
        String userId,
        int petLevel,
        int petExp,
        String petMood,
        String equippedHatId,
        String equippedOutfitId,
        String equippedBgId
) {
}

