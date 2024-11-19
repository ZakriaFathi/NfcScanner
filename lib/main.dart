import 'package:flutter/material.dart';
import 'nfc_scanner_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TestPage(),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showScanner() {
    final inputText = _controller.text;

    // Show the bottom sheet with the input text
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.cyan,
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: 0.5 * MediaQuery.of(context).size.height,
          ),
          child: AppNFCScanner(content: inputText),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a search term',
              ),
            ),
            SizedBox(height: 16), // Add some spacing
            Scan(onPressed: _showScanner),
          ],
        ),
      ),
    );
  }
}

class Scan extends StatelessWidget {
  final VoidCallback onPressed;

  const Scan({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Scan'),
      ),
    );
  }
}