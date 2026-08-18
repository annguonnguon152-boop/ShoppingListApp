import 'package:flutter/material.dart';
import 'package:shoppinglist_app/views/category_page.dart';
import 'package:shoppinglist_app/views/history_page.dart';
import 'package:shoppinglist_app/views/home_page.dart';
import 'package:shoppinglist_app/views/shopList_page.dart';
import 'package:shoppinglist_app/views/setting_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> pages = [
      const HomePage(),
      const ShoplistPage(),
      const CategoryPage(),
      const HistoryPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Container(
        height: 95,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade200,
            ),
          ),
        ),

        child: NavigationBar(
          height: 75,
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          selectedIndex: index,
          indicatorColor: const Color(0xFF12B76A),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          onDestinationSelected: (value) {
            setState(() {
              index = value;
            });
          },

          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.dashboard_outlined,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              selectedIcon: const Icon(Icons.dashboard, color: Colors.white),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              selectedIcon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: 'List',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.category_outlined,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              selectedIcon: const Icon(
                Icons.category_outlined,
                color: Colors.white,
              ),
              label: 'Categories',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.history_outlined,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              selectedIcon: const Icon(
                Icons.history_outlined,
                color: Colors.white,
              ),
              label: 'History',
            ),

            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              selectedIcon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
