import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/views/itemcatalog_page.dart';

class ShoplistPage extends ConsumerWidget {
  const ShoplistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text('MyShoppingList')),
      body: Column(children: [
 
],
    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? Color(0xFF12B76A) : const Color(0xFF00873E),
        foregroundColor: Colors.white,
        elevation: isDark ? 2 : 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemcatalogPage()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
