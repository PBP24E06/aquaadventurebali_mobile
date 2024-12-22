import 'package:aquaadventurebali_mobile/models/profile.dart';
import 'package:aquaadventurebali_mobile/screens/edit_profile.dart';
import 'package:aquaadventurebali_mobile/screens/forum/user_discussion_screen.dart';
import 'package:aquaadventurebali_mobile/screens/login.dart';
import 'package:aquaadventurebali_mobile/screens/menu.dart';
import 'package:aquaadventurebali_mobile/screens/register.dart';
import 'package:aquaadventurebali_mobile/screens/request_admin.dart';
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
           var response = await request.get('https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/show-profile-json/');
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

   Future<bool> checkLoginStatus(request) async {
       try {
           final response = await request.get('https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/is-logged-in-json/');
           return response['is_logged_in'];
       } catch (e) {
           return false;
       }
   }

   Widget _buildNotLoggedInView() {
       return Center(
           child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                   const Icon(
                       Icons.account_circle,
                       size: 100,
                       color: Colors.grey,
                   ),
                   const SizedBox(height: 20),
                   const Text(
                       'You are not logged in',
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                       ),
                   ),
                   const SizedBox(height: 20),
                   ElevatedButton(
                       onPressed: () {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                   builder: (context) => const LoginPage(),
                               ),
                           );
                       },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.deepPurple,
                           padding: const EdgeInsets.symmetric(
                               horizontal: 32,
                               vertical: 12,
                           ),
                       ),
                       child: const Text(
                           'Login',
                           style: TextStyle(color: Colors.white),
                       ),
                   ),
                   const SizedBox(height: 12),
                   ElevatedButton(
                       onPressed: () {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                   builder: (context) => const RegisterPage(),
                               ),
                           );
                       },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue,
                           padding: const EdgeInsets.symmetric(
                               horizontal: 32,
                               vertical: 12,
                           ),
                       ),
                       child: const Text(
                           'Register',
                           style: TextStyle(color: Colors.white),
                       ),
                   ),
               ],
           ),
       );
   }

   @override
   Widget build(BuildContext context) {
       final request = context.watch<CookieRequest>();
       
       return Scaffold(
           appBar: AppBar(
               title: const Text('Profile'),
           ),
           body: FutureBuilder<bool>(
               future: checkLoginStatus(request),
               builder: (context, loginSnapshot) {
                   if (loginSnapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                   }

                   if (loginSnapshot.data == true) {
                       return FutureBuilder<Profile?>(
                           future: fetchProfile(request),
                           builder: (context, profileSnapshot) {
                               if (profileSnapshot.connectionState == ConnectionState.waiting) {
                                   return const Center(child: CircularProgressIndicator());
                               }
                               if (profileSnapshot.hasError) {
                                   return Center(child: Text("Error: ${profileSnapshot.error}"));
                               }
                               if (!profileSnapshot.hasData || profileSnapshot.data == null) {
                                   return const Center(child: Text("Tidak ada profile."));
                               }

                               Profile profile = profileSnapshot.data!;
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
                                                                           "https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/static/ikon_botak/foto_ikon.jpg",
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
                                                       ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => const UserDiscussionScreen()),
                                                          );
                                                        },
                                                        child: const Text("My Discussions"),
                                                      ),


                                                       const SizedBox(height: 20),
                                                       ElevatedButton.icon(
                                                           onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => EditProfilePage())
                                                              );
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
                                                               if (profile.fields.role.toUpperCase() == 'ADMIN') {
                                                                   ScaffoldMessenger.of(context).showSnackBar(
                                                                       const SnackBar(
                                                                           content: Text('You are already an admin!'),
                                                                           backgroundColor: Colors.orange,
                                                                       ),
                                                                   );
                                                               } else {
                                                                   Navigator.push(
                                                                       context,
                                                                       MaterialPageRoute(
                                                                           builder: (context) => const RequestAdminPage(),
                                                                       ),
                                                                   );
                                                               }
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
                                                       const SizedBox(height: 20),
                                                       ElevatedButton.icon(
                                                           onPressed: () async {
                                                               final response = await request.logout("https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/auth/logout/");
                                                               String message = response["message"];
                                                               if (response['status']) {
                                                                   String uname = response["username"];
                                                                   Navigator.pushReplacement(
                                                                       context,
                                                                       MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                                   );
                                                                   ScaffoldMessenger.of(context)
                                                                       .showSnackBar(SnackBar(
                                                                       content: Text("$message Sampai jumpa, $uname."),
                                                                   ));
                                                               } else {
                                                                   ScaffoldMessenger.of(context)
                                                                       .showSnackBar(SnackBar(
                                                                       content: Text(message),
                                                                   ));
                                                               }
                                                           },
                                                           icon: const Icon(Icons.logout),
                                                           label: const Text('Logout'),
                                                           style: ElevatedButton.styleFrom(
                                                               backgroundColor: Colors.red,
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
                       );
                   } else {
                       return _buildNotLoggedInView();
                   }
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