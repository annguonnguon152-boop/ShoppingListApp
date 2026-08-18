import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/database/shoppingList_helper.dart';
import 'package:shoppinglist_app/model/user_model.dart';

class UserNotifier extends AsyncNotifier<UserModel> {
  final ShoppinglistHelper helper = ShoppinglistHelper();

  @override
  FutureOr<UserModel> build() async {
    return await helper.getUser();
  }

  void changeName(String newName) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(name: newName));
  }

  void changeEmail(String newEmail) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(email: newEmail));
  }

  void changePhone(String newPhone) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(phone: newPhone));
  }

  void changePreference(String newPreference) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(email: newPreference));
  }

  void changeStoreLocation(String newLocation) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(email: newLocation));
  }

  void changeImage(String newImage) {
    final user = state.value;

    if (user == null) {
      return;
    }
    state = AsyncData(user.copyWith(image: newImage));
  }

  // update user
  Future<void> updateUser() async {
    final user = state.value;

    if (user == null) return;

    await helper.updateUser(user);
  }

  // cancel edit
  Future<void> reloadUser() async {
    state = AsyncLoading();
    state = AsyncData(await helper.getUser());
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserModel>(
  UserNotifier.new,
);
