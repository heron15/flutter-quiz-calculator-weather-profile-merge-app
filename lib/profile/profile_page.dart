import 'package:flutter/material.dart';
import 'package:four_in_one_app/material/color.dart';
import 'package:four_in_one_app/profile/profile.dart';
import 'package:four_in_one_app/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage1 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage1> {
  Profile userProfile = Profile(
    name: "John Doe",
    bio: "Flutter Developer",
    photoUrl: "https://example.com/profile.jpg",
    contactEmail: "john.doe@example.com",
    contactPhone: "+1 123-456-7890",
    projects: [],
  );

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userProfile = Profile.fromSharedPreferences(prefs);
    });
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userProfile.saveToSharedPreferences(prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80.0,
              backgroundImage: NetworkImage(userProfile.photoUrl),
            ),
            SizedBox(height: 16.0),
            Text(
              userProfile.name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(userProfile.bio, textAlign: TextAlign.center),
            SizedBox(height: 16.0),
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Email: ${userProfile.contactEmail}'),
            Text('Phone: ${userProfile.contactPhone}'),
            SizedBox(height: 16.0),
            Text(
              'Portfolio',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: userProfile.projects.map((project) {
                return InkWell(
                  onTap: () => _launchURL(project.link),
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(project.description),
                          SizedBox(height: 8.0),
                          Text(
                            'Link: ${project.link}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileEditScreen(userProfile),
            ),
          ).then((updatedProfile) {
            if (updatedProfile != null) {
              setState(() {
                userProfile = updatedProfile;
              });
              _saveProfile();
            }
          });
        },
        tooltip: 'Edit Profile',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}