import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/cart_controller.dart';
import 'package:shoppinglist_app/controller/notification_controller.dart';
import 'package:shoppinglist_app/controller/shopping_list_controller.dart';
import 'package:shoppinglist_app/controller/shoppinglistdetail_controller.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';

Future<int?> showSaveCartToListDialog(
  BuildContext context,
  WidgetRef ref, {
  ShoppingListModel? editingList,
  bool completeAfterSave = false,
}) async {
  final isEdit = editingList != null;

  final oldReminder = DateTime.tryParse(editingList?.reminderDate ?? '');

  final hasReminder =
      oldReminder != null && oldReminder.isAfter(DateTime.now());

  final listNameController = TextEditingController(
    text: editingList?.listName ?? '',
  );

  bool setReminder = !completeAfterSave && hasReminder;

  DateTime? selectedDate = setReminder ? oldReminder : null;

  TimeOfDay? selectedTime = setReminder
      ? TimeOfDay.fromDateTime(oldReminder!)
      : null;

  try {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogBodyContext, setState) {
            final isDark =
                Theme.of(dialogBodyContext).brightness == Brightness.dark;

            final backgroundColor = isDark
                ? const Color(0xFF1E1E1E)
                : Colors.white;

            final surfaceColor = isDark
                ? const Color(0xFF292929)
                : const Color(0xFFF8FAFC);

            final borderColor = isDark
                ? const Color(0xFF3F3F3F)
                : const Color(0xFFE4E7EC);

            final textColor = isDark ? Colors.white : const Color(0xFF101828);

            final subTextColor = isDark
                ? Colors.grey.shade400
                : const Color(0xFF667085);

            final String title;
            final String subtitle;
            final String buttonText;
            final IconData headerIcon;
            final IconData buttonIcon;

            if (completeAfterSave) {
              title = 'Complete Shopping';
              subtitle = 'Save this purchase to your shopping history';
              buttonText = 'Complete Purchase';
              headerIcon = Icons.check_circle_outline_rounded;
              buttonIcon = Icons.check_rounded;
            } else if (isEdit) {
              title = 'Update Shopping List';
              subtitle = 'Update your existing shopping plan';
              buttonText = 'Update List';
              headerIcon = Icons.edit_note_rounded;
              buttonIcon = Icons.save_as_outlined;
            } else {
              title = 'Save Shopping List';
              subtitle = 'Save your cart for later';
              buttonText = 'Save List';
              headerIcon = Icons.playlist_add_check_rounded;
              buttonIcon = Icons.bookmark_add_outlined;
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),

              child: Container(
                width: 430,
                constraints: const BoxConstraints(maxHeight: 680),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // header
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF12B76A,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              headerIcon,
                              color: const Color(0xFF12B76A),
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: subTextColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // list name
                      Text(
                        'List Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: listNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'e.g. Weekly Groceries',
                          hintStyle: TextStyle(color: subTextColor),
                          prefixIcon: const Icon(
                            Icons.edit_note_rounded,
                            color: Color(0xFF12B76A),
                          ),
                          filled: true,
                          fillColor: surfaceColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF12B76A),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      // reminder only for save/update
                      if (!completeAfterSave) ...[
                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: setReminder
                                ? const Color(
                                    0xFF12B76A,
                                  ).withValues(alpha: isDark ? 0.12 : 0.07)
                                : surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: setReminder
                                  ? const Color(
                                      0xFF12B76A,
                                    ).withValues(alpha: 0.45)
                                  : borderColor,
                            ),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF12B76A,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.notifications_active_outlined,
                                  color: Color(0xFF12B76A),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Set Reminder',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      isEdit
                                          ? 'Update when you want to be reminded'
                                          : 'Get notified when it is time to shop',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Switch(
                                value: setReminder,
                                activeThumbColor: const Color(0xFF12B76A),
                                onChanged: (value) {
                                  setState(() {
                                    setReminder = value;

                                    if (!value) {
                                      selectedDate = null;

                                      selectedTime = null;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        if (setReminder) ...[
                          const SizedBox(height: 18),

                          Text(
                            'Reminder Schedule',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: _ReminderPickerCard(
                                  icon: Icons.calendar_month_outlined,
                                  title: 'Date',
                                  value: selectedDate == null
                                      ? 'Select'
                                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                  isDark: isDark,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: dialogBodyContext,
                                      initialDate:
                                          selectedDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(
                                        DateTime.now().year + 5,
                                      ),
                                    );

                                    if (!dialogBodyContext.mounted) {
                                      return;
                                    }

                                    if (date != null) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _ReminderPickerCard(
                                  icon: Icons.schedule_rounded,
                                  title: 'Time',
                                  value: selectedTime == null
                                      ? 'Select'
                                      : selectedTime!.format(dialogBodyContext),
                                  isDark: isDark,
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: dialogBodyContext,
                                      initialTime:
                                          selectedTime ?? TimeOfDay.now(),
                                    );

                                    if (!dialogBodyContext.mounted) {
                                      return;
                                    }

                                    if (time != null) {
                                      setState(() {
                                        selectedTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 15,
                                color: subTextColor,
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  'You will receive a notification at the selected date and time.',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: subTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],

                      // complete message
                      if (completeAfterSave) ...[
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF12B76A,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xFF12B76A),
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  'All items will be marked as purchased and this shopping list will be moved to your purchase history.',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 26),

                      // buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 50),
                                side: BorderSide(color: borderColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: () {
                                final listName = listNameController.text.trim();

                                if (listName.isEmpty) {
                                  ScaffoldMessenger.of(
                                    dialogBodyContext,
                                  ).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Please enter a list name'),
                                    ),
                                  );

                                  return;
                                }

                                DateTime? reminderDate;

                                if (!completeAfterSave && setReminder) {
                                  if (selectedDate == null ||
                                      selectedTime == null) {
                                    ScaffoldMessenger.of(
                                      dialogBodyContext,
                                    ).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Please select reminder date and time',
                                        ),
                                      ),
                                    );

                                    return;
                                  }

                                  reminderDate = DateTime(
                                    selectedDate!.year,
                                    selectedDate!.month,
                                    selectedDate!.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                  );

                                  if (!reminderDate.isAfter(DateTime.now())) {
                                    ScaffoldMessenger.of(
                                      dialogBodyContext,
                                    ).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Reminder must be in the future',
                                        ),
                                      ),
                                    );

                                    return;
                                  }
                                }

                                Navigator.pop(dialogContext, <String, dynamic>{
                                  'listName': listName,
                                  'reminderDate': reminderDate,
                                });
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF12B76A),
                                minimumSize: const Size(0, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(buttonIcon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    buttonText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) {
      return null;
    }

    if (!context.mounted) {
      return null;
    }

    final String listName = result['listName'] as String;

    final DateTime? reminderDate = result['reminderDate'] as DateTime?;

    // request permission only when reminder used
    if (reminderDate != null) {
      await NotificationController.requestNotificationPermission();
    }

    // update existing list
    // update existing list
    if (isEdit) {
      await ref
          .read(shoppingListProvider.notifier)
          .updateShoppingListFromCart(
            listId: editingList.id!,
            listName: listName,
            reminderDate: reminderDate,
          );

      // reload saved list details
      await ref.read(shoppingListDetailProvider.notifier).reloadData();

      // clear temporary cart
      await ref.read(cartProvider.notifier).clearCart();

      // stop editing this saved list
      ref.read(editingShoppingListProvider.notifier).state = null;

      if (!context.mounted) {
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text('"$listName" updated successfully')),
            ],
          ),
        ),
      );

      return editingList.id;
    }
    // create new list
    final listId = await ref
        .read(shoppingListProvider.notifier)
        .saveCartToShoppingList(listName: listName, reminderDate: reminderDate);

    // complete normal cart
    if (completeAfterSave) {
      await ref
          .read(shoppingListProvider.notifier)
          .completeShoppingList(listId);

      await ref.read(cartProvider.notifier).clearCart();

      ref.read(editingShoppingListProvider.notifier).state = null;

      await ref.read(shoppingListDetailProvider.notifier).reloadData();

      if (!context.mounted) {
        return null;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text('"$listName" completed successfully')),
            ],
          ),
        ),
      );

      return listId;
    }

    // normal save
    await ref.read(cartProvider.notifier).clearCart();

    ref.read(editingShoppingListProvider.notifier).state = null;

    await ref.read(shoppingListDetailProvider.notifier).reloadData();

    if (!context.mounted) {
      return null;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text('"$listName" saved successfully')),
          ],
        ),
      ),
    );

    return listId;
  } catch (e) {
    if (!context.mounted) {
      return null;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
      ),
    );

    return null;
  } finally {
    listNameController.dispose();
  }
}

class _ReminderPickerCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  const _ReminderPickerCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : const Color(0xFF101828);

    final subTextColor = isDark
        ? Colors.grey.shade400
        : const Color(0xFF667085);

    final surfaceColor = isDark
        ? const Color(0xFF292929)
        : const Color(0xFFF8FAFC);

    final borderColor = isDark
        ? const Color(0xFF3F3F3F)
        : const Color(0xFFE4E7EC);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF12B76A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF12B76A)),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 11, color: subTextColor),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
