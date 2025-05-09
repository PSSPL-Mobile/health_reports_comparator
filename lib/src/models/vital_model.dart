///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/05/25
/// @Message : [VitalModel]
///
class VitalModel {
  final String title;
  final String valueA;
  final String valueB;
  final String unit;
  final String normalRange;
  final String status;

  VitalModel({
    required this.title,
    required this.valueA,
    required this.valueB,
    required this.unit,
    required this.normalRange,
    required this.status,
  });

  factory VitalModel.fromJson(Map<String, dynamic> json) {
    return VitalModel(
      title: json['title'],
      valueA: json['valueA'],
      valueB: json['valueB'],
      unit: json['unit'],
      normalRange: json['normalRange'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'valueA': valueA,
      'valueB': valueB,
      'unit': unit,
      'normalRange': normalRange,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'VitalCardModel(title: $title, valueA: $valueA, valueB: $valueB, unit: $unit, normalRange: $normalRange, status: $status)';
  }
}
