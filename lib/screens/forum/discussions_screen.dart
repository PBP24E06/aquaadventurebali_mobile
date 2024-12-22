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

class DiscussionScreens extends StatefulWidget {
  final String productId;
  final String? uname;
  final int userId;

  const DiscussionScreens(this.uname, this.userId, {Key? key, required this.productId}) : super(key: key);

  @override
  State<DiscussionScreens> createState() => _DiscussionScreensState();
}

class _DiscussionScreensState extends State<DiscussionScreens> {
  late Future<Map<int, List<Forum>>> _forumFuture;
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final request = context.read<CookieRequest>();
    _productFuture = fetchProduct(request, widget.productId);
    _forumFuture = fetchForum(request, widget.productId);
  }

  Future<Product> fetchProduct(CookieRequest request, String productId) async {
    final response = await request.get('http://127.0.0.1:8000/json-product/$productId');
    return Product.fromJson(response.first);
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
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, productSnapshot) {
          if (productSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (productSnapshot.hasError) {
            return Center(child: Text("Error: ${productSnapshot.error}"));
          } else if (productSnapshot.hasData) {
            final product = productSnapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Image.network(
                        "http://127.0.0.1:8000/${product.fields.gambar}",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.fields.name,
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
                                          builder: (context) => DiscussionPage(
                                            uname: widget.uname,
                                            productId: widget.productId,
                                            parentCommentsId: entry.key,
                                            userId: widget.userId,
                                            forum: entry.value,
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
                                          date: "${parentComment.fields.createdAt.month}/${parentComment.fields.createdAt.year}",
                                          message: parentComment.fields.message,
                                          userLoggedIn: widget.userId,
                                          commentedUser: parentComment.fields.user,
                                          forum: parentComment.pk,
                                          onDelete: () {
                                            setState(() => _fetchData());
                                          },
                                        ),
                                        if (firstReply != null)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                                            child: ForumMessage(
                                              avatarUrl: "https://via.placeholder.com/150",
                                              name: firstReply.fields.commenterName,
                                              date: "${firstReply.fields.createdAt.month}/${firstReply.fields.createdAt.year}",
                                              message: firstReply.fields.message,
                                              userLoggedIn: widget.userId,
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
                ),
                if (widget.userId != 0)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: DiscussionForm(
                      productId: widget.productId,
                      userId: widget.userId,
                      parentCommentsId: null,
                      uname: widget.uname!,
                      onCommentAdded: (newComment) {
                        setState(() => _fetchData());
                      },
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: Text("Produk tidak ditemukan"));
          }
        },
      ),
    );
  }
}
