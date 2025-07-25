import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BackendService {
  static Future<String?> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('server_ip');
    return ip != null ? "http://$ip" : null;
  }

  static Future<String?> getClipboard() async {
    final baseUrl = await getBaseUrl();
    if (baseUrl == null) return null;
    final response = await http.get(Uri.parse("$baseUrl/clipboard"));
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  // Add more API methods like uploadFile, sendClipboard, etc.
}
