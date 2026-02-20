package com.runpet.api.dto.payments;

import jakarta.validation.constraints.NotBlank;

public class PaymentVerifyRequest {
    @NotBlank
    private String userId;
    @NotBlank
    private String productId;
    @NotBlank
    private String platform;
    @NotBlank
    private String transactionId;
    @NotBlank
    private String receiptToken;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getReceiptToken() {
        return receiptToken;
    }

    public void setReceiptToken(String receiptToken) {
        this.receiptToken = receiptToken;
    }
}

