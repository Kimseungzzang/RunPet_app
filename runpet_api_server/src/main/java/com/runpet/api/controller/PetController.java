package com.runpet.api.controller;

import com.runpet.api.dto.pet.PetEquipRequest;
import com.runpet.api.dto.pet.PetResponse;
import com.runpet.api.model.PetState;
import com.runpet.api.service.PetService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/pet")
public class PetController {
    private final PetService petService;

    public PetController(PetService petService) {
        this.petService = petService;
    }

    @GetMapping
    public PetResponse getPet(@RequestParam String userId) {
        PetState pet = petService.getOrCreate(userId);
        return new PetResponse(
                pet.getUserId(),
                pet.getPetLevel(),
                pet.getPetExp(),
                pet.getPetMood(),
                pet.getEquippedHatId(),
                pet.getEquippedOutfitId(),
                pet.getEquippedBgId()
        );
    }

    @PostMapping("/equip")
    public PetResponse equip(@Valid @RequestBody PetEquipRequest req) {
        PetState pet = petService.getOrCreate(req.getUserId());
        pet.equip(req.getSlotType(), req.getItemId());
        return new PetResponse(
                pet.getUserId(),
                pet.getPetLevel(),
                pet.getPetExp(),
                pet.getPetMood(),
                pet.getEquippedHatId(),
                pet.getEquippedOutfitId(),
                pet.getEquippedBgId()
        );
    }
}

