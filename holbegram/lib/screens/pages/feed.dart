import 'package:flutter/material.dart';
import 'package:holbergram/utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Holbegram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
                Image.asset('assets/images/logo.png', height: 40),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              children: [
                Icon(Icons.add, size: 30),
                const SizedBox(width: 16),
                Icon(Icons.message_outlined , size: 30),
              ],
            ),
          ],
        ),
      ),
      body: const Posts(),
    );
  }
}
