package com.runpet.api.dto.payments;

import java.time.Instant;

public record PaymentVerifyResponse(
        String status,
        String userId,
        String productId,
        String transactionId,
        boolean noAdsActivated,
        int coinGranted,
        Instant verifiedAt
) {
}

