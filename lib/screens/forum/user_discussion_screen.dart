import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart';
Import the ProductPage

class UserDiscussionScreen extends StatefulWidget {
  final String uname;
  final int userId;

  const UserDiscussionScreen({required this.uname, required this.userId, Key? key})
      : super(key: key);

  @override
  State<UserDiscussionScreen> createState() => _UserDiscussionScreenState();
}

class _UserDiscussionScreenState extends State<UserDiscussionScreen> {
  late Future<Map<int, List<Forum>>> _forumFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final request = context.read<CookieRequest>();
    _forumFuture = fetchForum(request, widget.userId);
  }

  Future<Map<int, List<Forum>>> fetchForum(CookieRequest request, int userId) async {
    final response = await request.get("http://127.0.0.1:8000/show_user_forum_json_mobile/$userId/");
    var data = response["discussions"];
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Text(
                "Diskusi Pengguna",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => setState(() => _fetchData()),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<int, List<Forum>>>(
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
                final remainingRepliesCount = replies.length > 1 ? replies.length - 1 : 0;

                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: parentComment.fields.productId, // Pass the productId
                                uname: widget.uname,
                              ),
                            ),
                          ).then((_) => setState(() => _fetchData()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ForumMessage(
                              avatarUrl: "https://via.placeholder.com/150",
                              name: parentComment.fields.commenterName,
                              date:
                                  "${parentComment.fields.createdAt.month}/${parentComment.fields.createdAt.year}",
                              message: parentComment.fields.message,
                              userLoggedIn: widget.userId,
                              commentedUser: parentComment.fields.user,
                              forum: parentComment.pk,
                              onDelete: () {
                                setState(() => _fetchData());
                              },
                            ),
                            if (replies.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                                child: ForumMessage(
                                  avatarUrl: "https://via.placeholder.com/150",
                                  name: replies[0].fields.commenterName,
                                  date:
                                      "${replies[0].fields.createdAt.month}/${replies[0].fields.createdAt.year}",
                                  message: replies[0].fields.message,
                                  userLoggedIn: widget.userId,
                                  commentedUser: replies[0].fields.user,
                                  forum: replies[0].pk,
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
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 188, 188, 188),
                      height: 1,
                      thickness: 1,
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text("Belum terdapat diskusi"));
          }
        },
      ),
    );
  }
}
