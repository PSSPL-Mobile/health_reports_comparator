import 'package:flutter/material.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/05/25
/// @Message : [HealthSummaryCard]
///
class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key, required this.keyChanges});
  final List<String> keyChanges;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Summary',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: keyChanges.map((element) => Text(
                '🚀 $element', style: TextStyle(
                fontSize: 14.5,
                color: Colors.black87,
              ),
              )).toList(),
            )
          ],
        ),
      ),
    );
  }
}