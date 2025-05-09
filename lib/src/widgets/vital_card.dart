import 'package:flutter/material.dart';
import 'package:health_reports_comparator_gemini/src/models/vital_model.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/05/25
/// @Message : [VitalCard]
///
class VitalCard extends StatelessWidget {
  final VitalModel vitalModel;

  const VitalCard({
    super.key,
    required this.vitalModel,
  });

  Icon? _getStatusIcon() {
    switch (vitalModel.status) {
      case 'improved':
        return const Icon(Icons.trending_up, color: Colors.green, size: 18.0);
      case 'worsened':
        return const Icon(Icons.trending_down, color: Colors.red, size: 18.0);
      default:
        return const Icon(Icons.remove, color: Colors.grey, size: 18.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                vitalModel.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const Spacer(),
              _getStatusIcon() ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: vitalModel.valueA,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                    children: [
                      TextSpan(
                        text: vitalModel.unit,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
              Text.rich(
                TextSpan(
                  text: vitalModel.valueB,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                  children: [
                    TextSpan(
                      text: vitalModel.unit,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            'Normal range: ${vitalModel.normalRange}',
            style: const TextStyle(color: Colors.grey, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}