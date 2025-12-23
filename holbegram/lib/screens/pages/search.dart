import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:holbergram/widgets/text_field.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFieldInput(
              controller: _searchController,
              isPassword: false,
              hintText: 'Search',
              keyboardType: TextInputType.text,
            ),
          ),

          // Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Center(child: Text("No posts found."));
                }

                return SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2, // Total columns
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: List.generate(data.length, (index) {
                      final post = data[index];

                      // Logic: The first item (index 0) is "Featured"
                      final isFeatured = index == 0;

                      return StaggeredGridTile.count(
                        // If featured, take up 2 columns; else take 1
                        crossAxisCellCount: isFeatured ? 2 : 1,
                        // If featured, make it taller (2 units); else 1 unit
                        mainAxisCellCount: isFeatured ? 2 : 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
