import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  String name;
  String bio;
  String photoUrl;
  String contactEmail;
  String contactPhone;
  List<Project> projects;

  Profile({
    required this.name,
    required this.bio,
    required this.photoUrl,
    required this.contactEmail,
    required this.contactPhone,
    this.projects = const [],
  });

  // Factory method to create a Profile from SharedPreferences
  factory Profile.fromSharedPreferences(SharedPreferences prefs) {
    return Profile(
      name: prefs.getString('name') ?? '',
      bio: prefs.getString('bio') ?? '',
      photoUrl: prefs.getString('photoUrl') ?? '',
      contactEmail: prefs.getString('contactEmail') ?? '',
      contactPhone: prefs.getString('contactPhone') ?? '',
      projects: _getProjectsFromSharedPreferences(prefs),
    );
  }

  // Helper method to get projects from SharedPreferences
  static List<Project> _getProjectsFromSharedPreferences(SharedPreferences prefs) {
    final projectCount = prefs.getInt('projectCount') ?? 0;
    List<Project> projects = [];
    for (int i = 0; i < projectCount; i++) {
      projects.add(
        Project(
          name: prefs.getString('projectName$i') ?? '',
          description: prefs.getString('projectDescription$i') ?? '',
          link: prefs.getString('projectLink$i') ?? '',
        ),
      );
    }
    return projects;
  }

  // Method to save the profile to SharedPreferences
  void saveToSharedPreferences(SharedPreferences prefs) {
    prefs.setString('name', name);
    prefs.setString('bio', bio);
    prefs.setString('photoUrl', photoUrl);
    prefs.setString('contactEmail', contactEmail);
    prefs.setString('contactPhone', contactPhone);
    _saveProjectsToSharedPreferences(prefs);
  }

  // Helper method to save projects to SharedPreferences
  void _saveProjectsToSharedPreferences(SharedPreferences prefs) {
    prefs.setInt('projectCount', projects.length);
    for (int i = 0; i < projects.length; i++) {
      final project = projects[i];
      prefs.setString('projectName$i', project.name);
      prefs.setString('projectDescription$i', project.description);
      prefs.setString('projectLink$i', project.link);
    }
  }
}

class Project {
  String name;
  String description;
  String link;

  Project({
    required this.name,
    required this.description,
    required this.link,
  });
}
