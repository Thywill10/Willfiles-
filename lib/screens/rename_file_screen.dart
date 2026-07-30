import 'package:flutter/material.dart';

class RenameFileScreen extends StatefulWidget {
  final String oldName;

  const RenameFileScreen({
    super.key,
    required this.oldName,
  });

  @override
  State<RenameFileScreen> createState() => _RenameFileScreenState();
}

class _RenameFileScreenState extends State<RenameFileScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.oldName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("Rename File"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: controller,

              decoration: InputDecoration(
                labelText: "New File Name",
                prefixIcon: const Icon(Icons.edit),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Rename"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),

                onPressed: () {
                  Navigator.pop(
                    context,
                    controller.text,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}