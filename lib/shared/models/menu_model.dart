class MenuModel {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String kategori;
  final String description;

  MenuModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.kategori,
    required this.description,
  });

  String get priceFormatted =>
      'Rp ' +
      price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  MenuModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? price,
    String? kategori,
    String? description,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      kategori: kategori ?? this.kategori,
      description: description ?? this.description,
    );
  }
}
