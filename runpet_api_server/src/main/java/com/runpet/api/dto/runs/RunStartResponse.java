package com.runpet.api.dto.runs;

import java.time.Instant;

public record RunStartResponse(
        String runId,
        String userId,
        Instant startedAt,
        String status
) {
}

