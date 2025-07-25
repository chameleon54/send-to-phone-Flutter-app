import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = "http://<YOUR-PC-IP>:5000";

  // Get clipboard text from PC
  static Future<String?> getClipboard() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/clipboard"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["clipboard"];
      } else {
        print("Failed to get clipboard: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  // Send clipboard text to PC
  static Future<bool> sendClipboard(String text) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/clipboard"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": text}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
