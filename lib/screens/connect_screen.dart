import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final TextEditingController _ipController = TextEditingController();
  bool _scanning = false;

  void _saveAndNavigate(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  void _onQRCodeScanned(String data) {
    if (data.startsWith("http://") || data.contains(".")) {
      _saveAndNavigate(data);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid QR data: $data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connect to Server")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_scanning)
              Container(
                height: 300,
                child: MobileScanner(
                  onDetect: (BarcodeCapture capture) {
                    final barcode = capture.barcodes.first;
                    final data = barcode.rawValue;

                    if (data != null) {
                      setState(() => _scanning = false);
                      _onQRCodeScanned(data);
                    }
                  },
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => setState(() => _scanning = true),
                icon: Icon(Icons.qr_code),
                label: Text("Scan QR Code"),
              ),
            SizedBox(height: 20),
            Text("Or enter IP manually"),
            TextField(
              controller: _ipController,
              decoration:
                  InputDecoration(labelText: "Server IP (e.g. 192.168.1.4:5000)"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final ip = _ipController.text.trim();
                if (ip.isNotEmpty) _saveAndNavigate(ip);
              },
              child: Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
