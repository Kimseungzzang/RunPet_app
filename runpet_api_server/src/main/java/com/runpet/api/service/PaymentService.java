package com.runpet.api.service;

import com.runpet.api.dto.payments.PaymentVerifyRequest;
import com.runpet.api.dto.payments.PaymentVerifyResponse;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class PaymentService {
    public PaymentVerifyResponse verify(PaymentVerifyRequest req) {
        if (req.getReceiptToken().length() < 10) {
            throw new IllegalArgumentException("Invalid receipt token");
        }

        boolean noAdsActivated = req.getProductId().toLowerCase().contains("no_ads");
        int coinGranted = req.getProductId().toLowerCase().contains("coin_pack") ? 2000 : 0;

        return new PaymentVerifyResponse(
                "verified",
                req.getUserId(),
                req.getProductId(),
                req.getTransactionId(),
                noAdsActivated,
                coinGranted,
                Instant.now()
        );
    }
}

