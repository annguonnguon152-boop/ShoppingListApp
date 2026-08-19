// ignore_for_file: unnecessary_non_null_assertion

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/controller/image_controller.dart';
import 'package:shoppinglist_app/controller/user_controller.dart';
import 'package:shoppinglist_app/views/widgets/changephotodialog_widget.dart';
import 'package:shoppinglist_app/views/widgets/profile_widget.dart';

class EditprofilePage extends ConsumerWidget {
  const EditprofilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(userProvider);
    final imageController = ref.watch(imageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FB);
    final textColor = isDark
        ? const Color(0xFFF8F9FB)
        : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 82,

        leading: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 12),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            await ref.read(userProvider.notifier).reloadUser();

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Text(
            'Cancel',
            softWrap: false,
            maxLines: 1,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade300 : Color(0xFF475467),
            ),
          ),
        ),

        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(userProvider.notifier).updateUser();
              ref.read(imageProvider).clearImage();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.check_rounded, color: Color(0xFF12B76A), size: 22),
          ),
          SizedBox(width: 4),
        ],
      ),
      body: data.when(
        data: (data) {
          // ignore: invalid_null_aware_operator
          final String image = data.image?.isNotEmpty == true
              ? data.image!
              : 'Assets/image.png';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 135,
                          height: 135,
                          padding: const EdgeInsets.all(2.5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF12B76A),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF121212)
                                  : Colors.white,
                            ),

                            child: ClipOval(
                              child: image.startsWith('Assets/')
                                  ? Image.asset(
                                      image,
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(image),
                                      width: 74,
                                      height: 74,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              'Assets/image.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 85,
                          top: 105,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return changePhotoDialog(
                                    context: dialogContext,
                                    ref: ref,
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Color(0xFF1E1E1E)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? Color(0xFF344054)
                                      : Color(0xFFE4E7EC),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF12B76A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Change photo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF12B76A),
                    ),
                  ),

                  SizedBox(height: 25),
                  // personal information
                  profileSection(
                    context: context,
                    title: 'Personal Information',
                    children: [
                      profileField(
                        context: context,
                        title: 'Full Name',
                        value: data.name,
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                        onChanged: (value) {
                          ref.read(userProvider.notifier).changeName(value);
                        },
                      ),
                       SizedBox(height: 14),

                      profileField(
                        context: context,
                        title: 'Email Address',
                        value: data.email,
                        hint: 'Enter your email',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          ref.read(userProvider.notifier).changeEmail(value);
                        },
                      ),
                       SizedBox(height: 14),
                      profileField(
                        context: context,
                        title: 'Phone Number',
                        value: data.phone,
                        hint: 'Enter phone number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          ref.read(userProvider.notifier).changePhone(value);
                        },
                      ),
                    ],
                  ),

                   SizedBox(height: 16),

                  // shopping preferences
                  profileSection(
                    context: context,
                    title: 'Shopping Preferences',

                    children: [
                      profileField(
                        context: context,
                        title: 'Dietary & Preferences',
                        value: data.preference,
                        hint: 'Organic only, No plastic bags',
                        icon: Icons.restaurant_outlined,
                        onChanged: (value) {
                          ref
                              .read(userProvider.notifier)
                              .changePreference(value);
                        },
                      ),

                       SizedBox(height: 10),

                      profileField(
                        context: context,
                        title: 'Primary Store Location',
                        value: data.storeLocation,
                        hint: 'Downtown Metro Market',
                        icon: Icons.storefront_outlined,
                        onChanged: (value) {
                          ref
                              .read(userProvider.notifier)
                              .changeStoreLocation(value);
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
        },

        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: textColor),
            ),
          );
        },
        loading: () {
          Center(child: CircularProgressIndicator(color: Color(0xFF12B76A)));
          return;
        },
      ),
    );
  }
}
