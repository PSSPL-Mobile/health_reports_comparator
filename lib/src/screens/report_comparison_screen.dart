import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:health_reports_comparator_gemini/src/models/vital_model.dart';
import 'package:health_reports_comparator_gemini/src/utils/file_picker.dart';
import 'package:health_reports_comparator_gemini/src/widgets/vital_card.dart';
import 'package:pdf_text/pdf_text.dart';

import '../models/output_schema.dart';
import '../widgets/health_summary_card.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/05/25
/// @Message : [ReportComparisonScreen]
///
class ReportComparisonScreen extends StatefulWidget {
  const ReportComparisonScreen({super.key});

  @override
  State<ReportComparisonScreen> createState() => _ReportComparisonScreenState();
}

class _ReportComparisonScreenState extends State<ReportComparisonScreen> {
  String? _filePath1;
  String? _filePath2;
  final List<VitalModel> vitalList = <VitalModel>[];
  final List<String> keyChanges = [];
  bool _isLoading = false;

  Widget _buildUploadCard(String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32.0,
              child: Icon(Icons.description_outlined,
                  color: Colors.blue.shade700, size: 36.0),
            ),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              onPressed: () async{
                if(label == 'Report 1'){
                  _filePath1 = await FilePickerUtil.instance.pickFile();
                }else{
                  _filePath2 = await FilePickerUtil.instance.pickFile();
                }
                setState(() {

                });
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ((label == 'Report 1' && _filePath1 != null) ||
                      (label == 'Report 2' && _filePath2 != null))? Colors.transparent: Colors.blue),
                  backgroundColor: ((label == 'Report 1' && _filePath1 != null) ||
                      (label == 'Report 2' && _filePath2 != null)) ? Colors.green: Colors.transparent
              ),
              child: Text(
                'Upload',
                style: TextStyle(color: ((label == 'Report 1' && _filePath1 != null) ||
                    (label == 'Report 2' && _filePath2 != null)) ? Colors.white: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Report Comparison'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined, color: Colors.blue,),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildUploadCard("Report 1"),
                        _buildUploadCard("Report 2"),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: ElevatedButton(
                        onPressed: () async{
                          await _compareReports();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Compare Reports',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filePath1 = null;
                          _filePath2 = null;
                          vitalList.clear();
                          keyChanges.clear();
                        });
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: vitalList.map((vital ) => VitalCard(
                            vitalModel: vital,
                          )).toList(),
                        ),

                        keyChanges.isNotEmpty? HealthSummaryCard(
                          keyChanges: keyChanges,
                        ): const SizedBox()
                      ],
                    ),
                  )
              )
            ],
          ),

          _isLoading? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ): const SizedBox()
        ],
      ),
    );
  }

  // Function to handle the comparison logic (placeholder)
  Future<void> _compareReports() async{
    if (_filePath1 != null && _filePath2 != null) {
      // --- Actual Comparison Logic Would Go Here ---
      print('Comparing Report 1: $_filePath1');
      print('Comparing Report 2: $_filePath2');
      vitalList.clear();
      setState(() {
        _isLoading = true;
      });

      PDFDoc pdfDoc1 = await PDFDoc.fromPath(_filePath1!);
      PDFDoc pdfDoc2 = await PDFDoc.fromPath(_filePath2!);

      String text1 = await pdfDoc1.pageAt(Random().nextInt(pdfDoc1.length) + 1).text;
      String text2 = await pdfDoc2.pageAt(Random().nextInt(pdfDoc2.length) + 1).text;

      // Show a confirmation or navigate to results screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Comparing: ${path.basename(_filePath1!)} and ${path.basename(_filePath2!)}')),
      );

      final gemini = Gemini.instance;

      final prompt = '''
      Compare the following two health reports and provide a clear, concise, and minimalistic summary of their differences:

      1. Focus on key vitals or health metrics.
      2. Present the values from both Report A and Report B.
      3. Indicate whether the metric has improved, worsened, or remained the same.
      
      Output format must be valid JSON, structured as follows:
      
      The top-level JSON must have two keys:
      
      Key 1: "vitals": a list of objects (all String type), each with the following keys:
      - "title": name of the health metric
      - "valueA": value from Report 1
      - "valueB": value from Report 2
      - "unit": measure unit
      - "normalRange": normal range for this metric
      - "status": one of "improved", "worsened", "nochange"
      
      Key 2:"key_changes": a list of concise summary strings highlighting the most important differences.
      
      Do not include markdown syntax or code block indicators like ```json.
      
      Only focus on the most relevant differences. Avoid repeating unchanged or unimportant data.
      
      Report 1:
      $text1
      
      Report 2:
      $text2
      ''';

      try{
        final result = await gemini.prompt(
            parts: [
              Part.text(prompt)
            ]
        );
        print(result?.output);
        if(vitalList.isNotEmpty){
          vitalList.clear();
        }
        final OutputSchema schema = OutputSchema.fromJson(jsonDecode(result?.output?? '{}'));
        vitalList.addAll(schema.vitals?? <VitalModel>[]);
       keyChanges.addAll(schema.keyChanges?? <String>[]);
      }
      catch(ex){
        print('Error : $ex');
      } finally{
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Should not happen if button is correctly disabled, but good practice
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both reports first.')),
      );
    }
  }
}