import 'dart:convert';
import 'package:aquaadventurebali_mobile/screens/detail_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';
import 'package:aquaadventurebali_mobile/widgets/forum/forum_message.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';

class UserDiscussionScreen extends StatefulWidget {
  const UserDiscussionScreen({Key? key}) : super(key: key);

  @override
  State<UserDiscussionScreen> createState() => _UserDiscussionScreenState();
}

class _UserDiscussionScreenState extends State<UserDiscussionScreen> {
  late Future<List<Map<String, dynamic>>> _discussionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final request = context.read<CookieRequest>();
    final userId = request.jsonData?["user_id"];
    if (userId != null) {
      _discussionsFuture = fetchUserDiscussions(request, userId);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserDiscussions(CookieRequest request, int userId) async {
    final response = await request.get("https://reyvano-mario-aquaadventurebali.pbp.cs.ui.ac.id/show_user_discussion_mobile_json/$userId/");

    if (!response.containsKey('discussions')) {
      throw Exception("Key 'discussions' not found in the API response");
    }

    final List<dynamic> discussionsData = response['discussions'];

    return discussionsData.map((entry) {
      final discussionData = jsonDecode(entry['discussion']) as Map<String, dynamic>;
      final productData = jsonDecode(entry['product']) as Map<String, dynamic>;

      return {
        'discussion': Forum.fromJson(discussionData),
        'product': Product.fromJson(productData),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                "Diskusi Pengguna",
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _discussionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final discussions = snapshot.data!;
            if (discussions.isEmpty) {
              return const Center(child: Text("Belum ada diskusi"));
            }

            return ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                final discussion = discussions[index]['discussion'] as Forum;
                final product = discussions[index]['product'] as Product;

                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)));
                  },
                  child: Column(
                    children: [
                      // Horizontal Layout for Product and Name
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Image.network(
                              "assets/${product.fields.gambar}",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey,
                                child: const Center(child: Text("No Image")),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Product Name
                            Expanded(
                              child: Text(
                                product.fields.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Parent Comment
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, bottom: 15.0),
                        child: ForumMessage(
                          avatarUrl: "https://via.placeholder.com/150",
                          name: discussion.fields.commenterName,
                          date: "${discussion.fields.createdAt.month}/${discussion.fields.createdAt.year}",
                          message: discussion.fields.message,
                          userLoggedIn: context.read<CookieRequest>().jsonData?["user_id"],
                          commentedUser: discussion.fields.user,
                          forum: discussion.pk,
                          onDelete: () => setState(() => _fetchData()),
                        ),
                      ),

                      const Divider(color: Color.fromARGB(255, 222, 221, 221), height: 1, thickness: 1),
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
    );
  }
}
