import 'dart:convert';
import 'package:aquaadventurebali_mobile/screens/forum/user_discussion_screen.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:aquaadventurebali_mobile/models/userprofile.dart';
import 'package:aquaadventurebali_mobile/screens/login.dart';

class UserProfileWidget extends StatefulWidget {
  final String uname;
  final int userId;

  const UserProfileWidget({this.uname = "Guest", this.userId = 0, super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  Future<UserProfile>? _userProfileFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    if (request.loggedIn) {
      _userProfileFuture = fetchUserProfile(request, widget.userId);
    }
  }

  Future<UserProfile> fetchUserProfile(CookieRequest request, int userId) async {
    final response = await request.get('http://127.0.0.1:8000/user_profile_json/$userId/');
    final jsonString = jsonEncode(response[0]);
    return userProfileFromJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile"),
        ),
        body: Column(
          children: [
            FutureBuilder<UserProfile>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Failed to load user profile: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final profile = snapshot.data!;
                  return _buildProfileUI(request, profile);
                } else {
                  return const Center(child: Text("No profile data available."));
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserDiscussionScreen()),
                );
              },
              child: const Text("My Discussions"),
            ),
          ],
        ),
      );
  }

  Widget _buildProfileUI(CookieRequest request,UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profile.fields.profilePicture.isNotEmpty
                  ? NetworkImage(profile.fields.profilePicture)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
          ),
          const SizedBox(height: 16),
          Text("Role: ${profile.fields.role}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("Alamat: ${profile.fields.alamat ?? '-'}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("Phone Number: ${profile.fields.phoneNumber ?? '-'}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("Birthdate: ${profile.fields.birthdate ?? '-'}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("Bio: ${profile.fields.bio ?? '-'}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text("Date Joined: ${profile.fields.dateJoined.toLocal()}", style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
