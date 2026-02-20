class PetModel {
  const PetModel({
    required this.userId,
    required this.petLevel,
    required this.petExp,
    required this.petMood,
    this.equippedHatId,
    this.equippedOutfitId,
    this.equippedBgId,
    this.coinBalance = 0,
  });

  final String userId;
  final int petLevel;
  final int petExp;
  final String petMood;
  final String? equippedHatId;
  final String? equippedOutfitId;
  final String? equippedBgId;
  final int coinBalance;

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      userId: json['userId'] as String,
      petLevel: json['petLevel'] as int,
      petExp: json['petExp'] as int,
      petMood: json['petMood'] as String,
      equippedHatId: json['equippedHatId'] as String?,
      equippedOutfitId: json['equippedOutfitId'] as String?,
      equippedBgId: json['equippedBgId'] as String?,
      coinBalance: (json['coinBalance'] as num?)?.toInt() ?? 0,
    );
  }
}
