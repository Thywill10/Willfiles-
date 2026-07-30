import 'package:flutter/material.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() =>
      _RecycleBinScreenState();
}

class _RecycleBinScreenState
    extends State<RecycleBinScreen> {

  final List<Map<String, String>> recycleBin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("Recycle Bin"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [

          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Empty Recycle Bin",
            onPressed: recycleBin.isEmpty
                ? null
                : () {
                    setState(() {
                      recycleBin.clear();
                    });

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Recycle Bin Emptied",
                        ),
                      ),
                    );
                  },
          ),

        ],
      ),

      body: recycleBin.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [

                  Icon(
                    Icons.delete_outline,
                    size: 100,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Recycle Bin is Empty",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Deleted files will appear here.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                ],
              ),
            )

          : ListView.builder(
              itemCount: recycleBin.length,
              itemBuilder: (context, index) {

                final file = recycleBin[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(

                    leading: const Icon(
                      Icons.insert_drive_file,
                      color: Colors.red,
                    ),

                    title: Text(file["name"]!),

                    subtitle: Text(
                      file["date"]!,
                    ),

                    trailing: PopupMenuButton(

                      itemBuilder: (_) => const [

                        PopupMenuItem(
                          value: "restore",
                          child: Text("Restore"),
                        ),

                        PopupMenuItem(
                          value: "delete",
                          child: Text(
                            "Delete Forever",
                          ),
                        ),

                      ],

                      onSelected: (value) {

                        if (value == "restore") {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "${file["name"]} restored",
                              ),
                            ),
                          );

                        }

                        if (value == "delete") {

                          setState(() {
                            recycleBin.removeAt(index);
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "${file["name"]} permanently deleted",
                              ),
                            ),
                          );

                        }

                      },

                    ),

                  ),
                );

              },
            ),

    );
  }
}