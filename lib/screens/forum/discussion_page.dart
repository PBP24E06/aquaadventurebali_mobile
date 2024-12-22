import 'package:flutter/material.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'discussion_form.dart'; // Modular form widget
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart'; // Modular message widget

class DiscussionPage extends StatefulWidget {
  final int? parentCommentsId;
  final String productId;
  final String? uname;
  final int userId;
  final List<Forum> forum;

  const DiscussionPage({
    required this.parentCommentsId,
    required this.productId,
    required this.uname,
    required this.userId,
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
    final parentComment = forumList[0]; // The main question
    final replies = forumList.skip(1).toList(); // Replies to the question

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
                      userLoggedIn: widget.userId,
                      commentedUser: parentComment.fields.user,
                      forum: parentComment.pk,
                      avatarUrl: "https://via.placeholder.com/150",
                      name: parentComment.fields.commenterName,
                      date:
                          "${parentComment.fields.createdAt.month}/${parentComment.fields.createdAt.year}",
                      message: parentComment.fields.message,
                      onDelete: () => setState(() {
                        forumList.removeAt(0); // Remove the parent comment
                      }),
                    ),
                  ),
                  const Divider(),
                  // Section header for replies
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      "Jawaban (${replies.length})",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(),
                  // Replies content
                  ...replies.map((reply) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ForumMessage(
                        userLoggedIn: widget.userId,
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
                    );
                  }).toList(),
                ],
              ),
            ),
            // Fixed comment input form at the bottom
            if (widget.uname != null)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: DiscussionForm(
                  productId: widget.productId,
                  userId: widget.userId,
                  parentCommentsId: widget.parentCommentsId,
                  uname: widget.uname!,
                  onCommentAdded: _addNewComment, // Pass the callback
                ),
              ),
          ],
        ),
      ),
    );
  }
}
