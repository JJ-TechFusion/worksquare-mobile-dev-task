class PropertyEntity {
  final int id;
  final String price;
  final int bedrooms;
  final int bathrooms;
  final String location;
  final String title;
  final List<String> status;
  final String image;
  final bool isFavorite;

  const PropertyEntity({
    required this.id,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.title,
    required this.status,
    required this.image,
    this.isFavorite = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  PropertyEntity copyWith({
    int? id,
    String? price,
    int? bedrooms,
    int? bathrooms,
    String? location,
    String? title,
    List<String>? status,
    String? image,
    bool? isFavorite,
  }) {
    return PropertyEntity(
      id: id ?? this.id,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      location: location ?? this.location,
      title: title ?? this.title,
      status: status ?? this.status,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'PropertyEntity{id: $id, title: $title, price: $price, location: $location, isFavorite: $isFavorite}';
  }
}
