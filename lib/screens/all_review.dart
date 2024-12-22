import 'package:aquaadventurebali_mobile/models/review.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AllReviewPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;


  const AllReviewPage({
    super.key, 
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  @override
  State<AllReviewPage> createState() => _AllReviewPageState();
}

class _AllReviewPageState extends State<AllReviewPage> {
  Future<List<Review>> fetchReviews(CookieRequest request) async {
    final response = await request.get(
      'http://127.0.0.1:8000/show-json-review/${widget.productId}'
    );
    
    List<Review> listReview = [];
    for (var d in response) {
      if (d != null) {
        listReview.add(Review.fromJson(d));
      }
    }
    return listReview;
  }



  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String imageUrl = "assets/${widget.productImage}";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reviews'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No reviews yet'));
          }

          var reviews = snapshot.data!;
          double avgRating = 0;
          if (reviews.isNotEmpty) {
            avgRating = reviews.fold(0.0, (sum, review) => sum + review.fields.rating) / reviews.length;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('Image not available'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Product Name
                Text(
                  widget.productName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                // Overall Rating
                Row(
                  children: [
                    Text(
                      reviews.isEmpty ? '' : 'Rating: ${avgRating.toStringAsFixed(1)} / 5.0',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reviews.isEmpty ? '(No reviews yet)' : '(${reviews.length} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reviews List
                Text(
                  reviews.isEmpty ? '' : 'Reviews',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...reviews.map((review) => Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.fields.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${review.fields.rating}.0',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (review.fields.reviewText.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(review.fields.reviewText),
                        ],
                      ],
                    ),
                  ),
                )).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}