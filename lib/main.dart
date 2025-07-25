import 'package:flutter/material.dart';
import 'services/backend_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send to PC',
      home: ClipboardTestPage(),
    );
  }
}

class ClipboardTestPage extends StatefulWidget {
  @override
  _ClipboardTestPageState createState() => _ClipboardTestPageState();
}

class _ClipboardTestPageState extends State<ClipboardTestPage> {
  String clipboardText = "";
  TextEditingController controller = TextEditingController();

  void fetchClipboard() async {
    String? text = await BackendService.getClipboard();
    setState(() {
      clipboardText = text ?? "Failed to get clipboard.";
    });
  }

  void sendClipboard() async {
    bool success = await BackendService.sendClipboard(controller.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? "Clipboard sent!" : "Failed to send clipboard"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clipboard Test")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: fetchClipboard,
              child: Text("Get Clipboard from PC"),
            ),
            Text("PC Clipboard: $clipboardText"),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: "Text to send to PC"),
            ),
            ElevatedButton(
              onPressed: sendClipboard,
              child: Text("Send Clipboard to PC"),
            ),
          ],
        ),
      ),
    );
  }
}
