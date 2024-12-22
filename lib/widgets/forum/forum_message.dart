import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForumMessage extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String date;
  final String message;
  final int? userLoggedIn;
  final int commentedUser;
  final int forum;
  final VoidCallback onDelete;

  const ForumMessage({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.date,
    required this.message,
    required this.userLoggedIn,
    required this.commentedUser,
    required this.forum,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _deleteComment(BuildContext context) async {
    final url = "http://127.0.0.1:8000/delete_discussion/$forum/";

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["message"] == "Discussion deleted successfully.") {
          onDelete(); // Call the onDelete callback
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding for spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 15, // CircleAvatar size
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 6), // Space between avatar and text
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Date Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6), // Adjust spacing between name and date
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    // PopupMenu for delete option
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
                // Message Content
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
