import 'package:dreamdwell/features/properties/domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.price,
    required super.bedrooms,
    required super.bathrooms,
    required super.location,
    required super.title,
    required super.status,
    required super.image,
    super.isFavorite = false,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      price: json['price'] as String,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      location: json['location'] as String,
      title: json['title'] as String,
      status: List<String>.from(json['status'] as List),
      image: json['image'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'location': location,
      'title': title,
      'status': status,
      'image': image,
      'isFavorite': isFavorite,
    };
  }

  PropertyEntity toEntity() {
    return PropertyEntity(
      id: id,
      price: price,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      location: location,
      title: title,
      status: status,
      image: image,
      isFavorite: isFavorite,
    );
  }

  factory PropertyModel.fromEntity(PropertyEntity entity) {
    return PropertyModel(
      id: entity.id,
      price: entity.price,
      bedrooms: entity.bedrooms,
      bathrooms: entity.bathrooms,
      location: entity.location,
      title: entity.title,
      status: entity.status,
      image: entity.image,
      isFavorite: entity.isFavorite,
    );
  }

  @override
  PropertyModel copyWith({
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
    return PropertyModel(
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
}
