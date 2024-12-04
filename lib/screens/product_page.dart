import 'dart:collection';

import 'package:aquaadventurebali_mobile/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:aquaadventurebali_mobile/models/product.dart';
import 'package:aquaadventurebali_mobile/models/forum.dart';

class ProductPage extends StatefulWidget{
  final String productId;
  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();

  PreferredSizeWidget searchProductBar(BuildContext context){
    return AppBar(
      backgroundColor: const Color(0xFF1F2937),
      title: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Produk',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0.0,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile())
              );
              // Add action for chat icon
            },
          ),
        ],
      ),
    );
  }
}

class _ProductPageState extends State<ProductPage>{
  final TextEditingController _productId = TextEditingController();

  // creating hash map response <parent id >
  Future<Map<int, List<Forum>?>> fetchProduct(CookieRequest request) async{
    final response = await request.get("http://127.0.0.1:8000/show_mobile_forum_json/?productId=$productId");
    var data = response;


    Map<int, List<Forum>?> discussionMap = HashMap();
    for (var commentsJson in data) {
      Forum commentsDart = Forum.fromJson(commentsJson);

      if (commentsDart.fields.parent == null) {
        // If this comment has no parent (i.e., it's a top-level comment)
        if (discussionMap.containsKey(commentsDart.pk)) {
          // Update the existing list of comments for this parent
          List<Forum> commentsList = discussionMap[commentsDart.pk]!;
          commentsList[0] = commentsDart;
          discussionMap[commentsDart.pk] = commentsList;
        } else {
          // Create a new list and add the comment
          List<Forum> commentsList = <Forum>[];
          commentsList.add(commentsDart);
          discussionMap[commentsDart.pk] = commentsList;
        }
      } else {
        // If this comment has a parent (i.e., it's a child comment)
        if (discussionMap.containsKey(commentsDart.fields.parent)) {
          // Add this comment to the list of the parent's child comments
          List<Forum> commentsList = discussionMap[commentsDart.fields.parent]!;
          commentsList.add(commentsDart);
          discussionMap[commentsDart.fields.parent] = commentsList;
        } else {
          // Create a new list and add the child comment (if the parent doesn't exist yet)
          List<Forum> commentsList = <Forum>[];
          commentsList.add(commentsDart);
          discussionMap[commentsDart.fields.parent] = commentsList;
        }
      }
    }
    return discussionMap;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // TODO: implement build
    return Container(
      child: FutureBuilder(
        future: fetchProduct(request), 
        builder: (context, AsyncSnapshot snapshot){
          if (snapshot.data == null){
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData){
              return Column(
                children: [
                  Image.asset(""),
                  const Text("Belum ada Diskusi")
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  child: Column(
                    children: [
                      Text("${snapshot.data![index].fields.commenter_name}"),
                      Text("${snapshot.data![index].fields.message}")
                    ],
                  ),
              ),
            );
          }
        }
      }),
    );
  }
}