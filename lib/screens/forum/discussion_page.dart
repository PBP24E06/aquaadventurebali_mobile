import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'discussion_form.dart'; // Modular form widget
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart'; // Modular message widget

class DiscussionPage extends StatefulWidget {
  final int? parentCommentsId;
  final String productId;
  final List<Forum> forum;

  const DiscussionPage({
    required this.parentCommentsId,
    required this.productId,
    required this.forum,
    super.key,
  });

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late List<Forum> forumList;

  @override
  void initState() {
    super.initState();
    forumList = widget.forum; // Initialize with the provided forum list
  }

  void _addNewComment(Forum newComment) {
    setState(() {
      forumList.add(newComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final uname = request.jsonData?['username']; // Fetch username dynamically
    final userId = request.jsonData?['user_id']; // Fetch user ID dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Produk"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Parent comment at the top
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ForumMessage(
                      userLoggedIn: userId,
                      commentedUser: forumList[0].fields.user,
                      forum: forumList[0].pk,
                      avatarUrl: "https://via.placeholder.com/150",
                      name: forumList[0].fields.commenterName,
                      date:
                          "${forumList[0].fields.createdAt.month}/${forumList[0].fields.createdAt.year}",
                      message: forumList[0].fields.message,
                      onDelete: () => setState(() {
                        forumList.removeAt(0); // Remove the parent comment
                      }),
                    ),
                  ),
                  const Divider(color: Color.fromARGB(255, 222, 221, 221), height: 1, thickness: 1),
                  // Section header for replies
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    child: Text(
                      "Jawaban (${forumList.length - 1})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Replies content
                  ...forumList.skip(1).map((reply) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: ForumMessage(
                            userLoggedIn: userId,
                            commentedUser: reply.fields.user,
                            forum: reply.pk,
                            avatarUrl: "https://via.placeholder.com/150",
                            name: reply.fields.commenterName,
                            date:
                                "${reply.fields.createdAt.month}/${reply.fields.createdAt.year}",
                            message: reply.fields.message,
                            onDelete: () => setState(() {
                              forumList.remove(reply); // Remove the reply
                            }),
                          ),
                        ),
                        const Divider(color: Color.fromARGB(255, 222, 221, 221), height: 1, thickness: 1),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            // Fixed comment input form at the bottom
            if (uname != null)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: DiscussionForm(
                  productId: widget.productId,
                  parentCommentsId: widget.parentCommentsId,
                  onCommentAdded: _addNewComment, // Pass the callback
                ),
              ),
          ],
        ),
      ),
    );
  }
}
