package com.runpet.api.dto.runs;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class RunFinishRequest {
    @NotNull
    @DecimalMin(value = "0.1")
    private Double distanceKm;

    @NotNull
    @Min(1)
    private Integer durationSec;

    @NotNull
    @Min(1)
    private Integer avgPaceSec;

    @NotNull
    @Min(1)
    private Integer calories;

    public Double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public Integer getDurationSec() {
        return durationSec;
    }

    public void setDurationSec(Integer durationSec) {
        this.durationSec = durationSec;
    }

    public Integer getAvgPaceSec() {
        return avgPaceSec;
    }

    public void setAvgPaceSec(Integer avgPaceSec) {
        this.avgPaceSec = avgPaceSec;
    }

    public Integer getCalories() {
        return calories;
    }

    public void setCalories(Integer calories) {
        this.calories = calories;
    }
}

