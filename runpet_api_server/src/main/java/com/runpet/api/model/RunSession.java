package com.runpet.api.model;

import java.time.Instant;

public class RunSession {
    private final String runId;
    private final String userId;
    private final Instant startedAt;
    private boolean finished;

    public RunSession(String runId, String userId, Instant startedAt) {
        this.runId = runId;
        this.userId = userId;
        this.startedAt = startedAt;
        this.finished = false;
    }

    public String getRunId() {
        return runId;
    }

    public String getUserId() {
        return userId;
    }

    public Instant getStartedAt() {
        return startedAt;
    }

    public boolean isFinished() {
        return finished;
    }

    public void markFinished() {
        this.finished = true;
    }
}

