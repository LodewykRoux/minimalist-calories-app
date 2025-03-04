// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calories_app/models/base/base.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/number_service.dart';

enum UnitOfMeasureEnum {
  g,
  ml,
  items,
}

class FoodItem extends BaseModel {
  final String name;
  final UnitOfMeasureEnum uoM;
  final double quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final int userId;

  const FoodItem({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required this.name,
    required this.uoM,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.userId,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'],
        createdAt: json['createdAt'] != null
            ? DateService.fromUtcFromISOString(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateService.fromUtcFromISOString(json['updatedAt'])
            : null,
        deletedAt: json['deletedAt'] != null
            ? DateService.fromUtcFromISOString(json['deletedAt'])
            : null,
        name: json['name'],
        uoM: UnitOfMeasureEnum.values[json['uoM']],
        quantity: NumberService.checkDouble(json['quantity']),
        calories: NumberService.checkDouble(json['calories']),
        protein: NumberService.checkDouble(json['protein']),
        carbs: NumberService.checkDouble(json['carbs']),
        fat: NumberService.checkDouble(json['fat']),
        userId: json['userId'],
      );

  @override
  Map<String, Object?> toJson() => {
        ...super.toJson(),
        'name': name,
        'uoM': uoM.index,
        'quantity': quantity,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  FoodItem copyWith({
    String? name,
    UnitOfMeasureEnum? uoM,
    double? quantity,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    int? userId,
  }) {
    return FoodItem(
      id: id,
      createdAt: createdAt,
      deletedAt: deletedAt,
      updatedAt: updatedAt,
      name: name ?? this.name,
      uoM: uoM ?? this.uoM,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem && hashCode == other.hashCode);

  @override
  int get hashCode =>
      super.hashCode ^
      Object.hash(
        name,
        uoM,
        quantity,
        calories,
        protein,
        carbs,
        fat,
        userId,
      );

  static FoodItem computeSingle(Map<String, Object?> json) {
    return FoodItem.fromJson(json);
  }

  static List<FoodItem> computeMultiple(List<Object?> json) {
    return List<Map>.from(json)
        .map((e) => FoodItem.fromJson(Map<String, Object?>.from(e)))
        .toList();
  }
}
