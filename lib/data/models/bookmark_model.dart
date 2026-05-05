class BookmarkModel {
  int? id;
  late int productId;
  late String productTitle;
  late double price;
  late String imageUrl;
  late DateTime savedAt;

  BookmarkModel({
    this.id,
    required this.productId,
    required this.productTitle,
    required this.price,
    required this.imageUrl,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productTitle': productTitle,
      'price': price,
      'imageUrl': imageUrl,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'],
      productId: json['productId'],
      productTitle: json['productTitle'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      savedAt: DateTime.parse(json['savedAt']),
    );
  }
}