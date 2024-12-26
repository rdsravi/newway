import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newway/controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = profileController.user.value;
        if (user == null) {
          return Center(child: Text('User data not found.'));
        }

        // Handle nullable fields properly using ?. operator
        String profilePictureUrl = user.profilePictureUrl ?? 'assets/images/avatar.png';
        String name = user.name ?? '';
        String mobileNumber = user.mobileNumber ?? 'N/A';
        String email = user.email ?? 'N/A';
        String gender = user.gender ?? 'N/A';
        bool notificationsEnabled = user.notificationsEnabled ?? false;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profilePictureUrl.isNotEmpty
                      ? NetworkImage(profilePictureUrl)
                      : AssetImage('assets/images/avatar.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'User Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 2),
              SizedBox(height: 10),
              _buildUserInfo('Name', name),
              _buildUserInfo('Mobile No', mobileNumber),
              _buildUserInfo('Email', email),
              _buildUserInfo('Gender', gender),
              // _buildUserInfo('Address', user.address ?? 'N/A'),
              // _buildUserInfo('Date of Birth', user.dob ?? 'N/A'),
              // Add more fields as needed
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      profileController.updateNotifications(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    profileController.logout(context);
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        );

      }),
    );
  }

  // Helper method to build user info rows
  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// Placeholder for Edit Profile Page
class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Page'), // Add your edit profile fields here
      ),
    );
  }
}
