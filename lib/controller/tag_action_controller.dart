import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/tags_controller.dart';
import 'package:shoppinglist_app/model/tag_model.dart';
import 'package:shoppinglist_app/views/dialog/addmessage_dialog.dart';

class TagActionController {
  static void addTag({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController tagNameController,
    required List<TagModel> selectedTags,
    required String? selectedIconKey,
  }) {
    final tagName = tagNameController.text.trim();

    if (tagName.isEmpty) {
      showAddItemMessage(context, 'Please enter tag name');
      return;
    }

    if (selectedIconKey == null) {
      showAddItemMessage(context, 'Please choose an icon');
      return;
    }

    final exists = selectedTags.any(
      (tag) => tag.name.toLowerCase() == tagName.toLowerCase(),
    );

    if (exists) {
      showAddItemMessage(context, 'Tag already added');
      return;
    }

    if (selectedTags.length >= 5) {
      showAddItemMessage(context, 'Maximum 5 tags allowed');
      return;
    }

    final newTags = List<TagModel>.from(selectedTags);
    newTags.add(TagModel(name: tagName, iconKey: selectedIconKey));
    ref.read(tagsProvider.notifier).state = newTags;
    tagNameController.clear();

    ref.read(selectedTagIconProvider.notifier).state = null;
  }

  static void removeTag({
    required WidgetRef ref,
    required TagModel tag,
    required List<TagModel> selectedTags,
  }) {
    final newTags = List<TagModel>.from(selectedTags);

    newTags.remove(tag);

    ref.read(tagsProvider.notifier).state = newTags;
  }
}
