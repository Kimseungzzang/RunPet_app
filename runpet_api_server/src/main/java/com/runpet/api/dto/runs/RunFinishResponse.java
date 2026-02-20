package com.runpet.api.dto.runs;

public record RunFinishResponse(
        String runId,
        String userId,
        double distanceKm,
        int durationSec,
        int avgPaceSec,
        int calories,
        int expGained,
        int coinGained,
        int petLevel,
        int petExp
) {
}

