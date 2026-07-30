import 'package:flutter/material.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("WillFiles"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Good Evening 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Smart. Secure. Fast.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Storage",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.72,
                      minHeight: 10,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "91.2 GB / 128 GB Used",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Storage Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _storageBox(
                    Icons.image,
                    Colors.green,
                    "Images",
                    "3.2 GB",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _storageBox(
                    Icons.video_library,
                    Colors.red,
                    "Videos",
                    "18.4 GB",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _storageBox(
                    Icons.music_note,
                    Colors.purple,
                    "Music",
                    "2.1 GB",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _storageBox(
                    Icons.description,
                    Colors.orange,
                    "Documents",
                    "1.4 GB",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Access",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildCard(Icons.folder, "Internal Storage"),
                _buildCard(Icons.download, "Downloads"),
                _buildCard(Icons.image, "Images"),
                _buildCard(Icons.video_library, "Videos"),
                _buildCard(Icons.music_note, "Music"),
                _buildCard(Icons.description, "Documents"),
                _buildCard(Icons.android, "APK Files"),
                _buildCard(Icons.lock, "Secure Vault"),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Files",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _recentFile(
              Icons.picture_as_pdf,
              Colors.red,
              "Physics Notes.pdf",
              "Yesterday",
            ),

            _recentFile(
              Icons.image,
              Colors.green,
              "Holiday.jpg",
              "Today",
            ),

            _recentFile(
              Icons.video_library,
              Colors.blue,
              "Vacation.mp4",
              "2 days ago",
            ),

            _recentFile(
              Icons.music_note,
              Colors.purple,
              "Music.mp3",
              "3 days ago",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _buildCard(IconData icon, String title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.green, size: 45),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _storageBox(
    IconData icon,
    Color color,
    String title,
    String size,
    ) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            size,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget _recentFile(
  IconData icon,
  Color color,
  String title,
  String date,
) {
  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}