import 'package:flutter/material.dart';
import 'package:shoppinglist_app/model/shoppinglist_model.dart';

Widget shoppingListCard({
  required BuildContext context,
  required bool isDark,
  required ShoppingListModel list,
  required List<List<String>> items,
  required int itemCount,
  required double total,
  required VoidCallback onTap,
}) {
  final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

  final borderColor = isDark
      ? const Color(0xFF343434)
      : const Color(0xFFE4E7EC);

  final titleColor = isDark ? Colors.white : const Color(0xFF101828);

  final subtitleColor = isDark ? Colors.grey.shade400 : const Color(0xFF667085);

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12B76A).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF12B76A),
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LIST NAME
                        Text(
                          list.listName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),

                        SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: subtitleColor,
                            ),

                            SizedBox(width: 5),

                            // CREATE DATE
                            Text(
                              _formatShoppingDate(list.createDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12B76A).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF12B76A),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: borderColor),

            // ITEM PREVIEW
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
              child: items.isEmpty
                  ? Text(
                      'No items',
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    )
                  : Column(
                      children: items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${item[0]} (${item[1]})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : const Color(0xFF344054),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              Text(
                                item[2],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),

            // REMINDER
            if (list.reminderDate != null) ...[
              Divider(height: 1, color: borderColor),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF79009).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        size: 15,
                        color: Color(0xFFF79009),
                      ),
                    ),

                    SizedBox(width: 8),

                    Text(
                      'Reminder',
                      style: TextStyle(fontSize: 15, color: subtitleColor),
                    ),

                    Spacer(),

                    Text(
                      _formatReminderDate(list.reminderDate),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF79009),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            Divider(height: 1, color: borderColor),

            // BOTTOM SUMMARY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF292929)
                          : const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Estimated Total',
                    style: TextStyle(fontSize: 15, color: subtitleColor),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF12B76A),
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

String _formatShoppingDate(String? date) {
  if (date == null || date.isEmpty) {
    return 'No date';
  }

  final value = DateTime.tryParse(date);

  if (value == null) {
    return date;
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

  return '${months[value.month - 1]} ${value.day}, ${value.year}';
}

String _formatReminderDate(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }

  final value = DateTime.tryParse(date);

  if (value == null) {
    return '';
  }

  int hour = value.hour;

  final period = hour >= 12 ? 'PM' : 'AM';

  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour -= 12;
  }

  final minute = value.minute.toString().padLeft(2, '0');

  return '${value.day}/${value.month}/${value.year} '
      '$hour:$minute $period';
}
