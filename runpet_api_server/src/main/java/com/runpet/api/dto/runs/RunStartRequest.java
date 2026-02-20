package com.runpet.api.dto.runs;

import jakarta.validation.constraints.NotBlank;

public class RunStartRequest {
    @NotBlank
    private String userId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}

