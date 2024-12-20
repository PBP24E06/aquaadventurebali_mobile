import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AllReviewPage extends StatefulWidget {
  final String productId;
  final String productName;

  const AllReviewPage({
    super.key, 
    required this.productId,
    required this.productName,
  });

  @override
  State<AllReviewPage> createState() => _AllReviewPageState();
}

class _AllReviewPageState extends State<AllReviewPage> {
  Future<Map<String, dynamic>> fetchReviews(CookieRequest request) async {
    final response = await request.get(
      'http://127.0.0.1:8000/show-json-review/${widget.productId}'
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reviews'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchReviews(request),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No reviews yet'));
          }

          var reviews = snapshot.data!['reviews'] as List;
          double avgRating = 0;
          if (reviews.isNotEmpty) {
            avgRating = reviews.fold(0.0, (sum, review) => sum + review['fields']['rating']) / reviews.length;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      'Rating: ${avgRating.toStringAsFixed(1)} / 5.0',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${reviews.length} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reviews List
                Text(
                  'Reviews',
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
                              review['fields']['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${review['fields']['rating']}.0',
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
                        if (review['fields']['review_text']?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          Text(review['fields']['review_text']),
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