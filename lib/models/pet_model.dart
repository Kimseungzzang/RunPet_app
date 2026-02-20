class PetModel {
  const PetModel({
    required this.userId,
    required this.petLevel,
    required this.petExp,
    required this.petMood,
    this.equippedHatId,
    this.equippedOutfitId,
    this.equippedBgId,
  });

  final String userId;
  final int petLevel;
  final int petExp;
  final String petMood;
  final String? equippedHatId;
  final String? equippedOutfitId;
  final String? equippedBgId;

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      userId: json['userId'] as String,
      petLevel: json['petLevel'] as int,
      petExp: json['petExp'] as int,
      petMood: json['petMood'] as String,
      equippedHatId: json['equippedHatId'] as String?,
      equippedOutfitId: json['equippedOutfitId'] as String?,
      equippedBgId: json['equippedBgId'] as String?,
    );
  }
}

