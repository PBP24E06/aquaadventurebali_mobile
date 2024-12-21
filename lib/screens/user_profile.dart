import 'package:aquaadventurebali_mobile/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class UserProfile extends StatefulWidget {
    const UserProfile({super.key});

    @override
    State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
    Future<Profile?> fetchProfile(request) async {
        try {
            var response = await request.get('http://127.0.0.1:8000/show-profile-json/');
            if (response is List && response.isNotEmpty) {
                var profileData = response[0];
                return Profile.fromJson(profileData);
            } else {
                return null;
            }
        } catch (e) {
            return null;
        }
    }

    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Text('Profile'),
            ),
            body: FutureBuilder<Profile?>(
                future: fetchProfile(request),
                builder: (context, AsyncSnapshot<Profile?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text("Tidak ada profile."));
                    }

                    Profile profile = snapshot.data!;
                    return SingleChildScrollView(
                        child: Column(
                            children: [
                                Container(
                                    height: 200,
                                    color: Colors.deepPurple,
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: Colors.white,
                                                    child: profile.fields.profilePicture.isNotEmpty
                                                        ? ClipOval(
                                                            child: Image.network(
                                                                "http://127.0.0.1:8000/${profile.fields.profilePicture}",
                                                                width: 100,
                                                                height: 100,
                                                                fit: BoxFit.cover,
                                                                errorBuilder: (context, error, stackTrace) =>
                                                                    const Icon(Icons.person, size: 50),
                                                            ),
                                                        )
                                                        : const Icon(Icons.person, size: 50),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                    profile.fields.username,
                                                    style: const TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                    ),
                                                ),
                                                const SizedBox(height: 5),  
                                                Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16, vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                        profile.fields.role,
                                                        style: const TextStyle(
                                                            color: Colors.deepPurple,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                                // Profile information
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                        children: [
                                            _buildInfoTile(
                                                Icons.location_on,
                                                'Alamat',
                                                profile.fields.alamat ?? 'Belum diisi',
                                            ),
                                            _buildInfoTile(
                                                Icons.calendar_today,
                                                'Tanggal Lahir',
                                                profile.fields.birthdate?.toString() ?? 'Belum diisi',
                                            ),
                                            _buildInfoTile(
                                                Icons.phone,
                                                'Nomor Telepon',
                                                profile.fields.phoneNumber ?? 'Belum diisi',
                                            ),
                                            _buildInfoTile(
                                                Icons.person,
                                                'Bio',
                                                profile.fields.bio ?? 'Belum diisi',
                                            ),
                                            _buildInfoTile(
                                                Icons.access_time,
                                                'Tanggal Bergabung',
                                                profile.fields.dateJoined.toString(),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                    // TODO: Edit profile
                                                },
                                                icon: const Icon(Icons.edit),
                                                label: const Text('Edit Profile'),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.deepPurple,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 32, vertical: 12),
                                                ),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                  // TODO: Implement request admin
                                              },
                                              icon: const Icon(Icons.admin_panel_settings),
                                              label: const Text('Request Admin'),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 32, vertical: 12),
                                              ),
                                          ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    );
                },
            ),
        );
    }

    Widget _buildInfoTile(IconData icon, String label, String value) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
                children: [
                    Icon(icon, color: Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    label,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                    ),
                                ),
                                Text(
                                    value,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}