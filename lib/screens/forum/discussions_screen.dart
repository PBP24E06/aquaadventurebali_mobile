import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart';
import 'package:aquaadventurebali_mobile/screens/forum/discussion_page.dart';
import 'package:aquaadventurebali_mobile/screens/forum/discussion_form.dart';
import 'package:aquaadventurebali_mobile/models/product.dart' as product_model;

class DiscussionScreens extends StatefulWidget {
  final product_model.Fields product;
  final String productId;

  const DiscussionScreens({Key? key, required this.productId, required this.product}) : super(key: key);

  @override
  State<DiscussionScreens> createState() => _DiscussionScreensState();
}

class _DiscussionScreensState extends State<DiscussionScreens> {
  late Future<Map<int, List<Forum>>> _forumFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final request = context.read<CookieRequest>();
    _forumFuture = fetchForum(request, widget.productId);
  }

  Future<Map<int, List<Forum>>> fetchForum(CookieRequest request, String productId) async {
    final response = await request.get("http://127.0.0.1:8000/show_mobile_forum_json/$productId/");
    var data = jsonDecode(response["discussions"]);
    Map<int, List<Forum>> discussionMap = HashMap();

    for (var commentsJson in data) {
      Forum comment = Forum.fromJson(commentsJson);
      if (comment.fields.parent == null) {
        discussionMap.putIfAbsent(comment.pk, () => []);
        discussionMap[comment.pk]!.insert(0, comment);
      } else {
        discussionMap.putIfAbsent(comment.fields.parent!, () => []);
        discussionMap[comment.fields.parent!]!.add(comment);
      }
    }
    return discussionMap;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final uname = request.jsonData?['username']; // Retrieve username from CookieRequest
    final userId = request.jsonData?['user_id']; // Retrieve user ID from CookieRequest

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                "Pertanyaan Terkait Produk",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() => _fetchData()),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Image.network(
                  "assets/${widget.product.gambar}",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<int, List<Forum>>>(
              future: _forumFuture,
              builder: (context, forumSnapshot) {
                if (forumSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (forumSnapshot.hasError) {
                  return Center(child: Text("Error: ${forumSnapshot.error}"));
                } else if (forumSnapshot.hasData) {
                  final discussions = forumSnapshot.data!;
                  if (discussions.isEmpty) {
                    return const Center(child: Text("Belum ada diskusi"));
                  }

                  return ListView.builder(
                    itemCount: discussions.length,
                    itemBuilder: (context, index) {
                      final entry = discussions.entries.elementAt(index);
                      final parentComment = entry.value[0];
                      final replies = entry.value.sublist(1);
                      final firstReply = replies.isNotEmpty ? replies[0] : null;
                      final remainingRepliesCount = replies.length > 1 ? replies.length - 1 : 0;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscussionPage(
                                productId: widget.productId,
                                parentCommentsId: entry.key,
                                forum: entry.value,
                              ),
                            ),
                          ).then((_) => setState(() => _fetchData()));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ForumMessage(
                                    avatarUrl: "https://via.placeholder.com/150",
                                    name: parentComment.fields.commenterName,
                                    date: "${parentComment.fields.createdAt.month}/${parentComment.fields.createdAt.year}",
                                    message: parentComment.fields.message,
                                    userLoggedIn: userId,
                                    commentedUser: parentComment.fields.user,
                                    forum: parentComment.pk,
                                    onDelete: () {
                                      setState(() => _fetchData());
                                    },
                                  ),
                                  if (firstReply != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: ForumMessage(
                                        avatarUrl: "https://via.placeholder.com/150",
                                        name: firstReply.fields.commenterName,
                                        date: "${firstReply.fields.createdAt.month}/${firstReply.fields.createdAt.year}",
                                        message: firstReply.fields.message,
                                        userLoggedIn: userId,
                                        commentedUser: firstReply.fields.user,
                                        forum: firstReply.pk,
                                        onDelete: () {
                                          setState(() => _fetchData());
                                        },
                                      ),
                                    ),
                                  if (remainingRepliesCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0, top: 8.0),
                                      child: Text(
                                        "$remainingRepliesCount jawaban lainnya",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color.fromARGB(255, 222, 221, 221),
                              height: 1,
                              thickness: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Belum terdapat diskusi"));
                }
              },
            ),
          ),
          if (userId != null && userId != 0)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: DiscussionForm(
                productId: widget.productId,
                parentCommentsId: null,
                onCommentAdded: (newComment) {
                  setState(() => _fetchData());
                },
              ),
            ),
        ],
      ),
    );
  }
}
