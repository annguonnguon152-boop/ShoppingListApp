class ShoppingListModel {
  final int? id;
  final String listName;

  final String? createDate;
  final String? completeDate;
  final String? reminderDate;

  final int? notificationId;
  final bool status;

  const ShoppingListModel({
    this.id,
    required this.listName,
    this.createDate,
    this.completeDate,
    this.reminderDate,
    this.notificationId,
    this.status = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'list_name': listName,
      'create_date': createDate,
      'complete_date': completeDate,
      'reminder_date': reminderDate,
      'notification_id': notificationId,
      'status': status ? 1 : 0,
    };
  }

  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'] as int?,
      listName: map['list_name']?.toString() ?? '',
      createDate: map['create_date']?.toString(),
      completeDate: map['complete_date']?.toString(),
      reminderDate: map['reminder_date']?.toString(),
      notificationId: map['notification_id'] as int?,
      status: map['status'] == 1,
    );
  }
}
