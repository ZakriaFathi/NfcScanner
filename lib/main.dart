import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nfc/dialog_extention.dart';
import 'package:nfc/nfc_scanner_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter NFC Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: const TestPage(),
        );
      },
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _controller = TextEditingController();
  final Random _random = Random();

  final List<String> _randomNfcContent = [
    '0002010102122727خ*************************ص2804IBAN2925LY07004061061011010028017309601030040217National business0364bfaf8719e0d10ba055d4c58d929a0e50d78e071cf96d65bde25b40fece9aa94f3115004P0000001140053034345402525802LY5927خ*************************ص6007Tripoli610615001362170303Pay0606QrCode63041072',
    '0002010102122727خال*********************باص2804IBAN2925LY07004061061011010028017309601030040217National business0364a99af92f87e31dcd2c4a73b4cc582ae6a6fb1201945a2bad21a1df5ee765ffef3115004P0000001139853034345402265802LY5927خال*********************باص6007Tripoli610615001362170303Pay0606QrCode6304999A',
    '0002010102122727خالد *****************بيباص2804IBAN2925LY07004061061011010028017309601030040217National business0364e6bb3274251d6cbe7f9c0caa7c0e41996e21776bfd5a7f6cd03c9b6d7bbd6a1d3115004P0000001139953034345402395802LY5927خالد *****************بيباص6007Tripoli610615001362170303Pay0606QrCode63046F26',
    '0002010102122727خالد عاشور عبد اللة البيباص2804IBAN2925LY07004061061011010028017309601030040217National business0364bdc25aecfde1db80b1319068d257d22e4febcb3aca7ed16b91d5c6a7400503c33115004P0000001139753034345402135802LY5927خالد عاشور عبد اللة البيباص6007Tripoli610615001362170303Pay0606QrCode63044041',
    '0002010102122724ايه******************يسى2804IBAN2925LY43004061061010118059019309601030040217National business0364809b840201bf56e9cb4760f5a73ea3431762cf6e06523876dfb9e153d9e9dfb23115004P0000001138853034345402305802LY5924ايه******************يسى6007Tripoli610615001362170303Pay0606QrCode6304835F'
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showScanner() {
    final inputText = _controller.text.trim();

    if (inputText.isEmpty) {
      if (mounted) {
        context.showMyAlertDialog(
          title: 'Input Required',
          description: 'Please enter NFC content.',
        );
      }
      return;
    }

    // Display the bottom sheet with the input text
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _NFCScannerBottomSheet(content: inputText),
    );
  }

  void _useRandomValue() {
    setState(() {
      // Set a random value from the list
      _controller.text = _randomNfcContent[_random.nextInt(_randomNfcContent.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC HCE'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputField(controller: _controller),
              SizedBox(height: 16.h),
              _SubmitButton(onPressed: _showScanner),
              SizedBox(height: 16.h),
              const Divider(),
              InkWell(
                onTap: _useRandomValue,
                child: const Text(
                  'Use random values',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;

  const _InputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 10,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter NFC content',
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Continue'),
      ),
    );
  }
}

class _NFCScannerBottomSheet extends StatelessWidget {
  final String content;

  const _NFCScannerBottomSheet({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      constraints: BoxConstraints(
        maxHeight: 0.5 * MediaQuery.of(context).size.height,
      ),
      child: AppNFCScanner(content: content),
    );
  }
}