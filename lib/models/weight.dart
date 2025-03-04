import 'package:calories_app/models/base/base.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/number_service.dart';

class Weight extends BaseModel {
  final DateTime date;
  final double weight;
  final int userId;

  const Weight({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
    required this.date,
    required this.weight,
    required this.userId,
  });

  factory Weight.fromJson(Map<String, dynamic> json) => Weight(
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
        date: DateService.fromUtcFromISOString(json['date']).toLocal(),
        weight: NumberService.checkDouble(json['weight']),
        userId: json['userId'],
      );

  @override
  Map<String, Object?> toJson() => {
        ...super.toJson(),
        'date': date.toUtc().toIso8601String(),
        'weight': weight,
        'userId': userId,
      };

  Weight copyWith({
    DateTime? date,
    double? weight,
    int? userId,
    int? foodItemsId,
  }) =>
      Weight(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        date: date ?? this.date,
        weight: weight ?? this.weight,
        userId: userId ?? this.userId,
      );

  @override
  int get hashCode =>
      super.hashCode ^
      Object.hash(
        date,
        weight,
        userId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Weight && hashCode == other.hashCode);

  static Weight computeSingle(Map<String, Object?> json) {
    return Weight.fromJson(json);
  }

  static List<Weight> computeMultiple(List<Object?> json) {
    return List<Map>.from(json)
        .map((e) => Weight.fromJson(Map<String, Object?>.from(e)))
        .toList();
  }
}
