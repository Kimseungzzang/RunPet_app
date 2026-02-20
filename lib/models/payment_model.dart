class PaymentVerifyResponseModel {
  const PaymentVerifyResponseModel({
    required this.status,
    required this.userId,
    required this.productId,
    required this.noAdsActivated,
    required this.coinGranted,
  });

  final String status;
  final String userId;
  final String productId;
  final bool noAdsActivated;
  final int coinGranted;

  factory PaymentVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentVerifyResponseModel(
      status: json['status'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      noAdsActivated: json['noAdsActivated'] as bool,
      coinGranted: json['coinGranted'] as int,
    );
  }
}

