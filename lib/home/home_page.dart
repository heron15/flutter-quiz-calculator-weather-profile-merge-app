import 'package:flutter/material.dart';
import 'package:four_in_one_app/material/all_link.dart';

import '../material/all_list.dart';
import '../material/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _loadImages() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: mainColor,
        elevation: 10,
        toolbarHeight: 50,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: mainColor),
                accountName: const Text("Heronmoy Biswas"),
                accountEmail: const Text("kumar15-3985@diu.edu.bd"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: mainColor,
        onRefresh: () async {
          await _loadImages();
          setState(() {});
        },
        child: FutureBuilder(
          future: _loadImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading images'),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                ),
                itemCount: imageItem.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle image tap
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: double.infinity,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        // Optional: Add borderRadius
                        child: Image.network(
                          imageItem[index]["img"]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
