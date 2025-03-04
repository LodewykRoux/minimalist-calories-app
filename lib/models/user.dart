import 'package:calories_app/models/base/base.dart';
import 'package:calories_app/models/daily_entry.dart';
import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/service/date_service.dart';

class User extends BaseModel {
  final String name;
  final String email;
  final List<FoodItem> foodItems;
  final List<DailyEntry> dailyEntry;
  final String token;

  const User({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required this.name,
    required this.email,
    required this.foodItems,
    required this.dailyEntry,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        email: json['email'],
        foodItems: json['foodItems'] != null ? [] : [],
        dailyEntry: json['dailyEntry'] != null ? [] : [],
        token: json['token'],
      );

  @override
  Map<String, Object?> toJson() => {
        ...super.toJson(),
        'name': name,
        'email': email,
        'foodItems': foodItems.map((e) => e.toJson()),
        'dailyEntry': dailyEntry.map((e) => e.toJson()),
        'token': token,
      };

  User copyWith({
    String? name,
    String? email,
    List<FoodItem>? foodItems,
    List<DailyEntry>? dailyEntry,
    String? token,
  }) =>
      User(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        name: name ?? this.name,
        email: email ?? this.email,
        foodItems: foodItems ?? this.foodItems,
        dailyEntry: dailyEntry ?? this.dailyEntry,
        token: token ?? this.token,
      );

  @override
  int get hashCode =>
      super.hashCode ^
      Object.hash(
        name,
        email,
        foodItems,
        dailyEntry,
        token,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is User && hashCode == other.hashCode);

  static User computeSingle(Map<String, Object?> json) {
    return User.fromJson(json);
  }
}
