import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:aquaadventurebali_mobile/models/profile.dart';

class ForumMessage extends StatelessWidget {
  final String name;
  final String date;
  final String message;
  final int? userLoggedIn;
  final int commentedUser;
  final int forum;
  final VoidCallback onDelete;

  const ForumMessage({
    Key? key,
    required this.name,
    required this.date,
    required this.message,
    required this.userLoggedIn,
    required this.commentedUser,
    required this.forum,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _deleteComment(BuildContext context) async {
    final request = context.read<CookieRequest>();
    final userId = request.jsonData?['user_id'];
    final url = "http://127.0.0.1:8000/delete_discussion_mobile/$forum/";

    try {
      final response = await http.delete(
        Uri.parse(url),
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["message"] == "Discussion deleted successfully.") {
          onDelete();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Komentar berhasil dihapus")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menghapus komentar")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus komentar")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  Future<Profile?> fetchProfile(CookieRequest request, int userId) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/show-profile-by-id-json/$userId');
      if (response is List && response.isNotEmpty) {
        return Profile.fromJson(response[0]);
      }
    } catch (e) {
      // Log error or handle fallback
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Profile?>(
            future: fetchProfile(request, commentedUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(radius: 15, backgroundColor: Colors.grey);
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data?.fields.profilePicture == null) {
                return const CircleAvatar(radius: 15, child: Icon(Icons.person), backgroundColor: Colors.grey);
              } else {
                return CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                    "http://127.0.0.1:8000/static/${snapshot.data!.fields.profilePicture}",
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 12), // Increase the spacing between the avatar and the name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    if (userLoggedIn != null && userLoggedIn == commentedUser)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'Hapus Komentar') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Hapus Komentar"),
                                  content: const Text("Apakah Anda yakin ingin menghapus komentar ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await _deleteComment(context);
                                      },
                                      child: const Text("Hapus Komentar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Hapus Komentar',
                            child: Text("Hapus Komentar"),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
