import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'discussion_form.dart';
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart';

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
    forumList = widget.forum;
  }

  void _addNewComment(Forum newComment) {
    setState(() {
      forumList.add(newComment);
    });
  }

  void _deleteComment(int index) {
    setState(() {
      forumList.removeAt(index);
      if (forumList.isEmpty) {
        Navigator.pop(context); // Pop the page if all comments are deleted
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final uname = request.jsonData?['username'];
    final userId = request.jsonData?['user_id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Produk"),
      ),
      body: SafeArea(
        child: forumList.isEmpty
            ? const Center(child: Text("Belum ada diskusi."))
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // Parent comment
                        ForumMessage(
                          userLoggedIn: userId,
                          commentedUser: forumList[0].fields.user,
                          forum: forumList[0].pk,
                          avatarUrl: "https://via.placeholder.com/150",
                          name: forumList[0].fields.commenterName,
                          date:
                              "${forumList[0].fields.createdAt.month}/${forumList[0].fields.createdAt.year}",
                          message: forumList[0].fields.message,
                          onDelete: () {
                            _deleteComment(0); // Delete the parent comment
                          },
                        ),
                        const Divider(color: Colors.grey, thickness: 1),
                        // Replies
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Jawaban (${forumList.length - 1})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...forumList.skip(1).map((reply) {
                          final index = forumList.indexOf(reply);
                          return Column(
                            children: [
                              ForumMessage(
                                userLoggedIn: userId,
                                commentedUser: reply.fields.user,
                                forum: reply.pk,
                                avatarUrl: "https://via.placeholder.com/150",
                                name: reply.fields.commenterName,
                                date:
                                    "${reply.fields.createdAt.month}/${reply.fields.createdAt.year}",
                                message: reply.fields.message,
                                onDelete: () {
                                  _deleteComment(index); // Delete a reply
                                },
                              ),
                              const Divider(color: Colors.grey, thickness: 1),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  // Comment form
                  if (uname != null)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: DiscussionForm(
                        productId: widget.productId,
                        parentCommentsId: widget.parentCommentsId,
                        onCommentAdded: _addNewComment,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
