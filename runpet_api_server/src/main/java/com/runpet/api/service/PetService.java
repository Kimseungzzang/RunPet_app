package com.runpet.api.service;

import com.runpet.api.model.PetState;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class PetService {
    private final Map<String, PetState> petsByUser = new ConcurrentHashMap<>();

    public PetState getOrCreate(String userId) {
        return petsByUser.computeIfAbsent(userId, PetState::new);
    }
}

