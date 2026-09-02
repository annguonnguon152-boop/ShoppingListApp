import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/favorite_controller.dart';
import 'package:shoppinglist_app/views/widgets/favorite_widget.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final favorites = ref.watch(favoriteItemsProvider);

    final filter = ref.watch(favoriteFilterProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF7F9FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,

        backgroundColor: isDark ? const Color(0xFF181818) : Colors.white,

        title:  Text(
          'My Favorites',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? const Color(0xFF303030) : const Color(0xFFE4E7EC),
          ),
        ),
      ),

      body: favorites.when(
        // DATA
        data: (data) {
          return Column(
            children: [
              // HEADER + FILTER
              favoriteHeader(
                context: context,
                itemCount: data.length,
                selectedFilter: filter,

                onFilter: () {
                  showFavoriteFilterSheet(
                    context: context,
                    ref: ref,
                    filterProvider: favoriteFilterProvider,
                    currentFilter: filter,
                  );
                },

                onClearFilter: () {
                  ref.read(favoriteFilterProvider.notifier).state = 'All';
                },
              ),

              // FAVORITE ITEMS
              Expanded(
                child: data.isEmpty
                    ? favoriteEmptyState(
                        context: context,
                        filter: filter,

                        onClear: () {
                          ref.read(favoriteFilterProvider.notifier).state =
                              'All';
                        },
                      )
                    : favoriteGrid(context: context, ref: ref, items: data),
              ),
            ],
          );
        },

        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF12B76A)),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Color(0xFFF04438),
                  ),

                   SizedBox(height: 14),

                   Text(
                    'Unable to Load Favorites',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),

                   SizedBox(height: 7),

                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.grey.shade400
                          : const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
