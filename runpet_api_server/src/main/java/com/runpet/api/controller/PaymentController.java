package com.runpet.api.controller;

import com.runpet.api.dto.payments.PaymentVerifyRequest;
import com.runpet.api.dto.payments.PaymentVerifyResponse;
import com.runpet.api.service.PaymentService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/payments")
public class PaymentController {
    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/verify")
    public PaymentVerifyResponse verify(@Valid @RequestBody PaymentVerifyRequest req) {
        return paymentService.verify(req);
    }
}

