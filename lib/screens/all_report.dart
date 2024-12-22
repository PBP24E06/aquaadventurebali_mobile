import 'package:aquaadventurebali_mobile/models/report.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AllReportPage extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;

  const AllReportPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  @override
  State<AllReportPage> createState() => _AllReportPageState();
}

class _AllReportPageState extends State<AllReportPage> {
  Future<List<Report>> fetchReports(CookieRequest request) async {
    final response = await request.get(
      'http://127.0.0.1:8000/show-json-report/${widget.productId}',
    );

    List<Report> listReport = [];
    for (var d in response) {
      if (d != null) {
        listReport.add(Report.fromJson(d));
      }
    }
    return listReport;
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
        title: const Text('Complaints'),
      ),
      body: FutureBuilder<List<Report>>(
        future: fetchReports(request),
        builder: (context, AsyncSnapshot<List<Report>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No complaints reported yet.'));
          }

          var reports = snapshot.data!;
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
                const SizedBox(height: 24),

                // Complaints Section
                Text(
                  'Complaints for ${widget.productName}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...reports.map((report) => Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.fields.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(report.fields.message),
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
