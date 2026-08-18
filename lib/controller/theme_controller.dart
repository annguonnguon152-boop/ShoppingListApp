import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  final ShoppinglistHelper helper = ShoppinglistHelper();
  @override
  Future<ThemeMode> build() async {
    bool isDark = await helper.getDarkMode();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> changeTheme(bool isDark) async {
    ThemeMode newTheme = isDark ? ThemeMode.dark : ThemeMode.light;
    state = AsyncData(newTheme);
    await helper.saveDarkMode(isDark);
  }
}

final themeProvider = AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
