import 'package:equatable/equatable.dart';
import '../core/utils/enums_utils.dart';

class MenuItemModel extends Equatable {
  final String id;
  final String name;
  final String restaurantId;
  final String description;
  final double price;
  final String? imageUrl;
  final MenuCategory category;
  final bool isVegetarian;
  final bool isAvailable;
  //final bool isSpicy;

  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.restaurantId,
    required this.category,
    required this.isVegetarian,
    required this.isAvailable,
    //required this.isSpicy,
  });

  // for JSON serialization
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      restaurantId: json['restaurantId'],
      category: MenuCategory.values.byName(json['category']),
      isVegetarian: json['isVegetarian'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
      //isSpicy: json['isSpicy'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'restaurantId': restaurantId,
      'category': category.name,
      'isVegetarian': isVegetarian,
      'isAvailable': isAvailable,
      //'isSpicy': isSpicy,
    };
  }

  @override
  List<Object?> get props => [id, name, description, price, imageUrl];
}
