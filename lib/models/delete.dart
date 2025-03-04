class Delete {
  final bool success;

  const Delete({required this.success});

  factory Delete.fromJson(Map<String, dynamic> json) => Delete(
        success: json['success'],
      );

  @override
  int get hashCode => success.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Delete && hashCode == other.hashCode);

  static Delete computeSingle(Map<String, Object?> json) {
    return Delete.fromJson(json);
  }
}
