import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/theme_controller.dart';
import 'package:shoppinglist_app/views/additem_page.dart';
import 'package:shoppinglist_app/views/favorite_page.dart';
import 'package:shoppinglist_app/views/editprofile_page.dart';
import 'package:shoppinglist_app/views/widgets/settings_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(themeProvider);
    final themeMode = provider.value ?? ThemeMode.light;
    final isDark = themeMode == ThemeMode.dark;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditprofilePage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,

                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade200,
                ),

                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),

              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 75,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'Assets/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 65,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFF12B76A),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.01),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {},
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ann',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        SizedBox(height: 5),
                        Text(
                          'annguon@gmail.com',
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Color(0xFFF3F4F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isDark ? Colors.grey.shade300 : Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Preference',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.shade200,
              ),

              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Column(
              children: [
                settingSwitchTile(
                  context: context,
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_outlined,

                  iconColor: isDark
                      ? const Color(0xFFFFC857)
                      : const Color(0xFF16A34A),

                  iconBackground: isDark
                      ? const Color(0xFF2D2D2D)
                      : const Color(0xFFEAF8EF),
                  title: 'Dark Mode',
                  subtitle: isDark
                      ? 'Dark theme is enabled'
                      : 'Switch to dark theme',
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).changeTheme(value);
                  },
                ),

                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.attach_money_rounded,
                  iconColor: Color(0xFF16A34A),
                  iconBackground: Color(0xFFEAF8EF),
                  title: 'Currency',
                  subtitle: 'Used for estimated cost',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFF1F2F3),

                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'USD (\$)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                settingDivider(context: context),

                settingSwitchTile(
                  context: context,
                  icon: Icons.notifications_none_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBackground: const Color(0xFFFFF4DD),
                  title: 'Notifications',
                  subtitle: 'Shopping reminders & updates',
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          SizedBox(height: 25),

          Text(
            'SHOPPING',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.shade200,
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),

            child: Column(
              children: [
                // Favorite
                settingTile(
                  context: context,
                  icon: Icons.favorite_border_rounded,
                  iconColor: const Color(0xFFE84A5F),
                  iconBackground: const Color(0xFFFFECEF),
                  title: 'Favorite Items',
                  subtitle: 'Quick access to your favorite items',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritePage()),
                    );
                  },
                ),

                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.category_outlined,
                  iconColor: Color(0xFF3B82F6),
                  iconBackground: Color(0xFFEAF2FF),
                  title: 'Manage Categories',
                  subtitle: 'Add and organize categories',
                  onTap: () {
                    // Open CategoryPage
                  },
                ),

                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.add_box_outlined,
                  iconColor: Color(0xFF16A34A),
                  iconBackground: Color(0xFFEAF8EF),
                  title: 'Add New Item',
                  subtitle: 'Create your own shopping item',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdditemPage()),
                    );
                  },
                ),

                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.history_rounded,
                  iconColor: Color(0xFF8B5CF6),
                  iconBackground: Color(0xFFF1EBFF),
                  title: 'Purchased History',
                  subtitle: 'View your previous purchases',
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 25),

          Text(
            'DATA & ABOUT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.shade200,
              ),

              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Column(
              children: [
                settingTile(
                  context: context,
                  icon: Icons.delete_outline_rounded,
                  iconColor: Color(0xFFEF4444),
                  iconBackground: Color(0xFFFFEEEE),
                  title: 'Clear History',
                  subtitle: 'Delete purchased item history',
                  onTap: () {},
                ),

                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.restart_alt_rounded,
                  iconColor: Color(0xFFEF4444),
                  iconBackground: Color(0xFFFFEEEE),
                  title: 'Reset App Data',
                  subtitle: 'Remove all saved app data',
                  titleColor: Color(0xFFEF4444),
                  onTap: () {},
                ),
                settingDivider(context: context),
                settingTile(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  iconColor: Color(0xFF16A34A),
                  iconBackground: Color(0xFFEAF8EF),
                  title: 'About App',
                  subtitle: 'App information and version',
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              'Shopping List • Version 1.0.0',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
