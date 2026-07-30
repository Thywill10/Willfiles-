import 'package:flutter/material.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final TextEditingController passwordController = TextEditingController();

  bool unlocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("Secure Vault"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: unlocked
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: const [

                ListTile(
                  leading: Icon(Icons.image, color: Colors.green),
                  title: Text("Private Photo.jpg"),
                ),

                Divider(),

                ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text("Secret Notes.pdf"),
                ),

                Divider(),

                ListTile(
                  leading: Icon(Icons.video_library, color: Colors.blue),
                  title: Text("Hidden Video.mp4"),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Secure Vault",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Enter your vault password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        if (passwordController.text == "1234") {
                          setState(() {
                            unlocked = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Wrong Password"),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text("Unlock Vault"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}