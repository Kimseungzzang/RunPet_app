class PetShopItemModel {
  const PetShopItemModel({
    required this.itemId,
    required this.slotType,
    required this.itemName,
    required this.priceCoin,
    required this.owned,
    required this.equipped,
  });

  final String itemId;
  final String slotType;
  final String itemName;
  final int priceCoin;
  final bool owned;
  final bool equipped;

  factory PetShopItemModel.fromJson(Map<String, dynamic> json) {
    return PetShopItemModel(
      itemId: json['itemId'] as String,
      slotType: json['slotType'] as String,
      itemName: json['itemName'] as String,
      priceCoin: (json['priceCoin'] as num).toInt(),
      owned: json['owned'] as bool,
      equipped: json['equipped'] as bool,
    );
  }
}

class PetShopResponseModel {
  const PetShopResponseModel({
    required this.coinBalance,
    required this.items,
  });

  final int coinBalance;
  final List<PetShopItemModel> items;

  factory PetShopResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? const []);
    return PetShopResponseModel(
      coinBalance: (json['coinBalance'] as num?)?.toInt() ?? 0,
      items: rawItems
          .cast<Map<String, dynamic>>()
          .map(PetShopItemModel.fromJson)
          .toList(),
    );
  }
}
