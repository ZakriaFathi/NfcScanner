import 'package:flutter/material.dart';
import 'package:flutter_nfc_hce/flutter_nfc_hce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nfc/dialog_extention.dart';

class AppNFCScanner extends StatefulWidget {
  final String content;

  const AppNFCScanner({super.key, required this.content});

  @override
  State<AppNFCScanner> createState() => _AppNFCScannerState();
}

class _AppNFCScannerState extends State<AppNFCScanner> {
  //plugin instance
  String message = '';
  final _flutterNfcHcePlugin = FlutterNfcHce();
  Future<bool> _isNFCEnabled() async {
    bool isNfcSupported = await _flutterNfcHcePlugin.isNfcHceSupported();
    bool isNfcEnabled = await _flutterNfcHcePlugin.isNfcEnabled();
    bool isNfcHceSupported = await _flutterNfcHcePlugin.isNfcHceSupported();
    return (isNfcSupported && isNfcEnabled && isNfcHceSupported);
  }

  Future<void> initNfcHce() async {
    final bool isNFCEnabled = await _isNFCEnabled();

    if (!isNFCEnabled) {
      if (mounted) {
        await context.showMyAlertDialog(
          title: 'NFC Issue',
          description: 'Please activate NFC from the phone settings.',
        ).then((v) {
          if (mounted) {
            Navigator.pop(context);
          }
        });// Optional: Navigate back after the alert
      }
    }

    try {
      // Stop any ongoing NFC session to avoid conflicts
      await _flutterNfcHcePlugin.stopNfcHce();

      // Start NFC HCE with the provided content
      await _flutterNfcHcePlugin.startNfcHce(widget.content);
      print("NFC HCE started successfully with content: ${widget.content}");

      // Wait for a while to keep the session active
      await Future.delayed(const Duration(seconds: 50));

      message = "NFC HCE initialized successfully.";
    } catch (e) {
      // Handle errors and update UI if mounted
      if (mounted) {
        await context.showMyAlertDialog(
          title: 'NFC Issue',
          description: "Error resetting NFC HCE: $e",
        ).then((v) {
          if (mounted) {
            Navigator.pop(context);
          }
        });// Optional: Navigate back after the alert
      }
    }
  }
  @override
  void initState() {
    initNfcHce();

    super.initState();
  }

  @override
  void dispose() {
    _flutterNfcHcePlugin.stopNfcHce();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const Text(
            'Ready to be scanned',
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 70.0,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.nfc,
            size: 55.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const Text(
            'Make you\'re phone closer to the device',
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              onPressed: () {
                _flutterNfcHcePlugin.stopNfcHce();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white)),
              child: const Text('Cancel')),
        ),
      ],
    );
  }
}
