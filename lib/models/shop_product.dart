class ShopProduct {
  const ShopProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.available,
  });

  final String id;
  final String title;
  final String description;
  final String priceLabel;
  final bool available;
}

