import 'package:flutter/foundation.dart';

@immutable
abstract class BaseModel {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Map<String, Object?> toJson() => {
        'id': id,
      };

  @override
  int get hashCode => Object.hash(
        id,
        createdAt,
        updatedAt,
        deletedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseModel && hashCode == other.hashCode);
}
