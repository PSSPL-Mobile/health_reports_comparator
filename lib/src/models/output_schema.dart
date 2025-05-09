import 'package:health_reports_comparator_gemini/src/models/vital_model.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 06/05/25
/// @Message : [OutputSchema]
///
class OutputSchema {
  List<VitalModel>? vitals;
  List<String>? keyChanges;

  OutputSchema({this.vitals});

  OutputSchema.fromJson(Map<String, dynamic> json) {
    if (json['vitals'] != null) {
      vitals = <VitalModel>[];
      json['vitals'].forEach((v) {
        vitals!.add(VitalModel.fromJson(v));
      });
    }
    if (json['key_changes'] != null) {
      keyChanges = <String>[];
      json['key_changes'].forEach((v) {
        keyChanges!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vitals != null) {
      data['vitals'] = vitals!.map((v) => v.toJson()).toList();
    }
    if (keyChanges != null) {
      data['key_changes'] = keyChanges!.map((v) => v.toString()).toList();
    }
    return data;
  }
}
