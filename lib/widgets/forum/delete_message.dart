import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class DeleteDropdown extends StatelessWidget {
  final int userLoggedIn;
  final int commentedUser;
  final int forum;
  final Function onDelete;
  final String deleteUrl;

  const DeleteDropdown({
    Key? key,
    required this.userLoggedIn,
    required this.commentedUser,
    required this.forum,
    required this.onDelete,
    required this.deleteUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userLoggedIn != commentedUser) {
      return const SizedBox.shrink(); // Return an empty widget if the user is not authorized
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'Hapus Komentar') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Hapus Komentar"),
                content: const Text("Apakah Anda ingin menghapus komentar ini?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final request = Provider.of<CookieRequest>(context, listen: false);
                      final response = await request.post(
                        deleteUrl,
                        jsonEncode(<String, int>{
                          'commentId': forum,
                        }),
                      );

                      Navigator.pop(context);

                      if (response["status"] == "success") {
                        onDelete(); // Call the onDelete callback
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Komentar berhasil dihapus"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Gagal menghapus komentar"),
                          ),
                        );
                      }
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
    );
  }
}
