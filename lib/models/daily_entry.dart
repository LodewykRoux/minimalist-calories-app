import 'package:calories_app/models/base/base.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/number_service.dart';

class DailyEntry extends BaseModel {
  final DateTime date;
  final double quantity;
  final int userId;
  final int foodItemsId;

  const DailyEntry({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required this.date,
    required this.quantity,
    required this.userId,
    required this.foodItemsId,
  });

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
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
        date: DateService.fromUtcFromISOString(json['date']),
        quantity: NumberService.checkDouble(json['quantity']),
        userId: json['userId'],
        foodItemsId: json['foodItemsId'],
      );

  @override
  Map<String, Object?> toJson() => {
        ...super.toJson(),
        'date': date.toUtc().toIso8601String(),
        'quantity': quantity,
        'userId': userId,
        'foodItemsId': foodItemsId,
      };

  DailyEntry copyWith({
    DateTime? date,
    double? quantity,
    int? userId,
    int? foodItemsId,
  }) =>
      DailyEntry(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        userId: userId ?? this.userId,
        foodItemsId: foodItemsId ?? this.foodItemsId,
      );

  @override
  int get hashCode =>
      super.hashCode ^ Object.hash(date, quantity, userId, foodItemsId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntry && hashCode == other.hashCode);

  static DailyEntry computeSingle(Map<String, Object?> json) {
    return DailyEntry.fromJson(json);
  }

  static List<DailyEntry> computeMultiple(List<Object?> json) {
    return List<Map>.from(json)
        .map((e) => DailyEntry.fromJson(Map<String, Object?>.from(e)))
        .toList();
  }
}
