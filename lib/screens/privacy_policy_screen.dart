import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Text(
          '''
WillFiles Privacy Policy

Your privacy is important to us.

WillFiles only accesses your device storage to help you manage your files.

We do not collect, upload or share your personal files.

Advertisements may be displayed using Google AdMob. Google may collect anonymous information as described in its own privacy policy.

By using WillFiles you agree to this privacy policy.

Thank you for using WillFiles.
''',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}