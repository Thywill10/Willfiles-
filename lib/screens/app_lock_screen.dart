import 'package:flutter/material.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() =>
      _AppLockScreenState();
}

class _AppLockScreenState
    extends State<AppLockScreen> {

  bool appLockEnabled = false;

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("App Lock"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor:
                  Colors.green.withOpacity(0.15),
              child: const Icon(
                Icons.lock,
                color: Colors.green,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Protect WillFiles",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Create a password to prevent unauthorized access.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            SwitchListTile(
              value: appLockEnabled,
              activeColor: Colors.green,
              title: const Text("Enable App Lock"),
              onChanged: (value) {
                setState(() {
                  appLockEnabled = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon:
                    const Icon(Icons.password),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon:
                    const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
                onPressed: () {

                  if (!appLockEnabled) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "App Lock Disabled",
                        ),
                      ),
                    );

                    return;
                  }

                  if (passwordController.text.isEmpty ||
                      confirmController.text.isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter your password",
                        ),
                      ),
                    );

                    return;
                  }

                  if (passwordController.text !=
                      confirmController.text) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Passwords do not match",
                        ),
                      ),
                    );

                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "App Lock Settings Saved",
                      ),
                    ),
                  );

                  Navigator.pop(context);

                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
