package com.runpet.api.controller;

import com.runpet.api.dto.runs.RunFinishRequest;
import com.runpet.api.dto.runs.RunFinishResponse;
import com.runpet.api.dto.runs.RunStartRequest;
import com.runpet.api.dto.runs.RunStartResponse;
import com.runpet.api.service.RunService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/runs")
public class RunController {
    private final RunService runService;

    public RunController(RunService runService) {
        this.runService = runService;
    }

    @PostMapping("/start")
    public RunStartResponse start(@Valid @RequestBody RunStartRequest req) {
        return runService.start(req.getUserId());
    }

    @PostMapping("/{runId}/finish")
    public RunFinishResponse finish(
            @PathVariable String runId,
            @Valid @RequestBody RunFinishRequest req
    ) {
        return runService.finish(runId, req);
    }
}

