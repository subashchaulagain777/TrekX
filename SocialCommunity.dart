import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/card/postcard.dart';
import '../main.dart';
import '../provider/PostProvider.dart';
import 'innerpage/createpost.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => postProvider.fetchPosts(),
        color: const Color(0xFF3897F0),
        backgroundColor: Colors.white,
        child: postProvider.isLoading
            ? _buildPostShimmerList()
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          itemCount: postProvider.posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: postProvider.posts[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
        },
        backgroundColor: const Color(0xFF3897F0),
        elevation: 2,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildPostShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[200]!, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  title: Container(
                    height: 14,
                    width: 120,
                    color: Colors.white,
                  ),
                  subtitle: Container(
                    height: 10,
                    width: 80,
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 60, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(height: 12, width: double.infinity, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(height: 12, width: double.infinity, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}