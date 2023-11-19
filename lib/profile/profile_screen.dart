import 'package:flutter/material.dart';
import 'package:four_in_one_app/material/color.dart';
import 'package:four_in_one_app/profile/profile.dart';

class ProfileEditScreen extends StatefulWidget {
  final Profile profile;

  ProfileEditScreen(this.profile);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController photoUrlController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  List<ProjectEditingController> projectControllers = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    bioController = TextEditingController(text: widget.profile.bio);
    photoUrlController = TextEditingController(text: widget.profile.photoUrl);
    emailController = TextEditingController(text: widget.profile.contactEmail);
    phoneController = TextEditingController(text: widget.profile.contactPhone);

    // Initialize project fields if there are existing projects
    if (widget.profile.projects.isNotEmpty) {
      for (var project in widget.profile.projects) {
        projectControllers.add(
          ProjectEditingController(
            name: project.name,
            description: project.description,
            link: project.link,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Add Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: bioController,
                decoration: InputDecoration(labelText: 'Bio'),
              ),
              TextField(
                controller: photoUrlController,
                decoration: InputDecoration(labelText: 'Photo URL'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Edit Projects',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              for (var i = 0; i < projectControllers.length; i++)
                _buildProjectFields(i),
              ElevatedButton(
                onPressed: () {
                  _addProject();
                },
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                ),
                child: Text('Add Another Project'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _saveProfile();
                  Navigator.pop(context, widget.profile);
                },
                style: ElevatedButton.styleFrom(
                  primary: mainColor,
                ),
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectFields(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project ${index + 1}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: projectControllers[index].nameController,
          decoration: InputDecoration(labelText: 'Project Name'),
        ),
        TextField(
          controller: projectControllers[index].descriptionController,
          decoration: InputDecoration(labelText: 'Project Description'),
        ),
        TextField(
          controller: projectControllers[index].linkController,
          decoration: InputDecoration(labelText: 'Project Link'),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  void _addProject() {
    setState(() {
      projectControllers.add(ProjectEditingController());
    });
  }

  void _saveProfile() {
    setState(() {
      widget.profile.name = nameController.text;
      widget.profile.bio = bioController.text;
      widget.profile.photoUrl = photoUrlController.text;
      widget.profile.contactEmail = emailController.text;
      widget.profile.contactPhone = phoneController.text;

      widget.profile.projects.clear();
      for (var controller in projectControllers) {
        widget.profile.projects.add(
          Project(
            name: controller.nameController.text,
            description: controller.descriptionController.text,
            link: controller.linkController.text,
          ),
        );
      }
    });
  }
}

class ProjectEditingController {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;

  ProjectEditingController({
    String name = '',
    String description = '',
    String link = '',
  }) {
    nameController = TextEditingController(text: name);
    descriptionController = TextEditingController(text: description);
    linkController = TextEditingController(text: link);
  }
}
