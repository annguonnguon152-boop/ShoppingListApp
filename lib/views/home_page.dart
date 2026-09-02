import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/history_controller.dart';
import 'package:shoppinglist_app/controller/item_controller.dart';
import 'package:shoppinglist_app/controller/shopping_list_controller.dart';
import 'package:shoppinglist_app/controller/shoppinglistdetail_controller.dart';
import 'package:shoppinglist_app/controller/user_controller.dart';
import 'package:shoppinglist_app/views/cart_page.dart';
import 'package:shoppinglist_app/views/editprofile_page.dart';
import 'package:shoppinglist_app/views/widgets/homestat_widget.dart';
import 'dart:io';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemData = ref.watch(itemProvider);
    final itemController = ref.read(itemProvider.notifier);
    final favCount = itemData.value?.where((e) => e.isFav == true).length ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userData = ref.watch(userProvider);
    final shoppingListData = ref.watch(shoppingListProvider);
    final shoppingListDetails = ref.watch(shoppingListDetailProvider);
    final historyData = ref.watch(historyProvider);
    final historyController = ref.read(historyProvider.notifier);

    final shoppingListController = ref.read(shoppingListProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF12B76A), width: 1.5),
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditprofilePage(),
                        ),
                      ),
                      child: userData.when(
                        data: (data) {
                          final String image = data.image.isNotEmpty
                              ? data.image
                              : 'Assets/image.png';

                          return CircleAvatar(
                            radius: 18,
                            backgroundImage: image.startsWith('Assets/')
                                ? AssetImage(image)
                                : FileImage(File(image)) as ImageProvider,
                          );
                        },
                        error: (error, stackTrace) {
                          return CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('Assets/image.png'),
                          );
                        },
                        loading: () {
                          return CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('Assets/image.png'),
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Shopping List App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Color(0xFF079455),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: isDark ? Colors.white : Color(0xFF079455),
                      size: 24,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Ready to Shop?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5),
              Text(
                'Let’s get your shopping list done.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'Total Items',
                      value: itemController.totalItems.toStringAsFixed(0),
                      iconColor: const Color(0xFF3D8B68),
                      iconBg: const Color(0xFFDDF8EC),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.inventory_2_outlined,
                      title: 'Remaining',
                      value: shoppingListController.remainingItems.toString(),
                      iconColor: const Color(0xFFF59E0B),
                      iconBg: const Color(0xFFFFEFCF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.check_circle_outline,
                      title: 'Purchased',
                      value: shoppingListController.purchasedItems.toString(),
                      iconColor: const Color(0xFF3B82F6),
                      iconBg: const Color(0xFFDDEBFF),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.payments_outlined,
                      title: 'Estimate Cost',
                      value:
                          '\$${shoppingListController.estimateCost.toStringAsFixed(2)}',
                      iconColor: const Color(0xFF607D8B),
                      iconBg: const Color(0xFFE2EFF3),
                      valueColor: const Color(0xFF35B84A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.favorite_outline,
                      title: 'Favorites',
                      value: favCount.toString(),
                      iconColor: const Color(0xFFEF4444),
                      iconBg: const Color(0xFFFEE2E2),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.payments_outlined,
                      title: 'Total Spents',
                      value:
                          '\$${historyController.totalSpent.toStringAsFixed(2)}',
                      iconColor: const Color(0xFF607D8B),
                      iconBg: const Color(0xFFE2EFF3),
                      valueColor: const Color(0xFF35B84A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Shopping List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All', style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),

              shoppingListData.when(
                data: (lists) {
                  if (lists.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF343434)
                              : const Color(0xFFE4E7EC),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.playlist_add_rounded,
                            size: 35,
                            color: Color(0xFF12B76A),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'No Shopping Lists Yet',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF101828),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Your recent saved lists will appear here.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final recentLists = lists.take(3).toList();

                  return shoppingListDetails.when(
                    data: (detailData) {
                      return Column(
                        children: recentLists.map((list) {
                          final details = detailData[list.id!] ?? [];

                          final totalItems = details.fold<int>(0, (
                            sum,
                            detail,
                          ) {
                            return sum + detail.quantity;
                          });

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: homeRecentShoppingList(
                              context: context,
                              isDark: isDark,
                              title: list.listName,
                              date: formatRecentListDate(list.createDate),
                              itemCount: totalItems,

                              onTap: () async {
                                final editingList = ref.read(
                                  editingShoppingListProvider,
                                );

                                // same list still being edited
                                if (editingList?.id == list.id) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const CartPage();
                                      },
                                    ),
                                  );

                                  return;
                                }

                                // replace cart with this list
                                await ref
                                    .read(cartProvider.notifier)
                                    .loadShoppingList(list.id!);

                                // remember current editing list
                                ref
                                        .read(
                                          editingShoppingListProvider.notifier,
                                        )
                                        .state =
                                    list;

                                if (!context.mounted) {
                                  return;
                                }

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CartPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },

                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    },

                    error: (error, stack) {
                      return Text(error.toString());
                    },
                  );
                },

                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },

                error: (error, stack) {
                  return Text(error.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatRecentListDate(String? dateString) {
    final date = DateTime.tryParse(dateString ?? '');

    if (date == null) {
      return 'No date';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}
