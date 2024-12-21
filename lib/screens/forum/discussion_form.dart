import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';

class DiscussionForm extends StatefulWidget {
  final int? parentCommentsId;
  final String productId;
  final int userId;
  final String uname;
  final Function(Forum) onCommentAdded; // Callback for adding a new comment

  const DiscussionForm({
    this.parentCommentsId,
    required this.productId,
    required this.userId,
    required this.uname,
    required this.onCommentAdded,
    super.key,
  });

  @override
  _DiscussionFormState createState() => _DiscussionFormState();
}

class _DiscussionFormState extends State<DiscussionForm> {
  final _formKey = GlobalKey<FormState>();
  String _comments = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Beri komentar",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.5)),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Komentar tidak boleh kosong";
                  } else {
                    _comments = value;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    print("ADD PARENT COMMENT ${widget.parentCommentsId}");
                    print("ADD USER ID ${widget.userId}");
                    print("ADD COMMENTER_NAME ${widget.uname}");
                    print("ADD COMMENTS $_comments");
                    final response = await request.post(
                      "http://127.0.0.1:8000/add_discussion_or_reply_mobile/${widget.productId}/",
                      jsonEncode(<String, dynamic>{
                        'parent_id': widget.parentCommentsId,
                        'user_id': widget.userId,
                        'commenter_name': widget.uname,
                        'comments': _comments,
                        'date': DateTime.now().toIso8601String(),
                      }),
                    );
                    print(response);
                    if (response != null && response['status'] == "success") {
                      print("Successfully added discussion");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sukses menambahkan diskusi")),
                      );
                      // Deserialize 'new_comment' and map it to a Forum object
                      final newCommentList = jsonDecode(response['new_comment']) as List<dynamic>;
                      final newCommentJson = newCommentList.first as Map<String, dynamic>;
                      final newComment = Forum.fromJson(newCommentJson);

                      print("NEW_COMMENT $newComment");
                      widget.onCommentAdded(newComment); // Trigger the callback
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal menambahkan diskusi")),
                      );
                    }
                  }
                },
                child: const Text("Beri Komentar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
