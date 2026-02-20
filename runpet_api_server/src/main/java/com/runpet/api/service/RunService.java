package com.runpet.api.service;

import com.runpet.api.dto.runs.RunFinishRequest;
import com.runpet.api.dto.runs.RunFinishResponse;
import com.runpet.api.dto.runs.RunStartResponse;
import com.runpet.api.model.PetState;
import com.runpet.api.model.RunSession;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RunService {
    private final Map<String, RunSession> sessions = new ConcurrentHashMap<>();
    private final PetService petService;

    public RunService(PetService petService) {
        this.petService = petService;
    }

    public RunStartResponse start(String userId) {
        String runId = UUID.randomUUID().toString();
        Instant startedAt = Instant.now();
        sessions.put(runId, new RunSession(runId, userId, startedAt));
        return new RunStartResponse(runId, userId, startedAt, "started");
    }

    public RunFinishResponse finish(String runId, RunFinishRequest req) {
        RunSession session = sessions.get(runId);
        if (session == null) {
            throw new IllegalArgumentException("runId not found: " + runId);
        }
        if (session.isFinished()) {
            throw new IllegalStateException("run already finished: " + runId);
        }
        session.markFinished();

        int durationMin = req.getDurationSec() / 60;
        int exp = (int) Math.floor(req.getDistanceKm() * 12 + durationMin * 1.5);
        int coin = (int) Math.floor(req.getDistanceKm() * 8);

        PetState pet = petService.getOrCreate(session.getUserId());
        pet.addExp(exp);

        return new RunFinishResponse(
                runId,
                session.getUserId(),
                req.getDistanceKm(),
                req.getDurationSec(),
                req.getAvgPaceSec(),
                req.getCalories(),
                exp,
                coin,
                pet.getPetLevel(),
                pet.getPetExp()
        );
    }
}

