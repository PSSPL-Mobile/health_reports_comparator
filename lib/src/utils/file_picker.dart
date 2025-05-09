import 'package:file_picker/file_picker.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 08/05/25
/// @Message : [FilePickerUtil]
///
class FilePickerUtil{
  static final FilePickerUtil _singleton = FilePickerUtil._();
  FilePickerUtil._();
  static FilePickerUtil get instance => _singleton;

  // Function to pick a PDF file and update the state
  Future<String?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      } else {
        // User canceled the picker or failed to get path
        print('File picking cancelled or failed.');
      }
    } catch (ex) {
      // Handle exceptions
      print("Error picking file: $ex");
    }
    return null;
  }
}