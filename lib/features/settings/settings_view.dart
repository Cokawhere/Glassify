import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/LiquidSnackBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/styles/colors.dart';
import '../../common/widgets/app_loader.dart';
import '../Auth/controller.dart';
import '../Auth/user_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    final nameController = TextEditingController(text: user.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(111, 2, 35, 26),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: AppColors.subfont),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.subfont),
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.subfont),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty && newName != user.name) {
                  await ref
                      .read(authController)
                      .updateUserProfile(context, name: newName);
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.subfont),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userStreamProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.pink, AppColors.white, AppColors.pink],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: userAsyncValue.when(
              data: (user) {
                if (user == null) {
                  return const Center(
                    child: Text(
                      'Not logged in',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: 20.h),
                    LiquidGlass(
                      shape: LiquidRoundedRectangle(
                        borderRadius: Radius.circular(18.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: NetworkImage(
                                user.imageUrl ??
                                    "https://i.pinimg.com/1200x/10/d3/eb/10d3eb63d65c49f45148b61142d9b22d.jpg",
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight
                                          .bold, // Consider .sp if needed
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 18, // Consider .sp if needed
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _showEditProfileDialog(
                                      context,
                                      ref,
                                      user,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    LiquidGlass(
                      shape: LiquidRoundedRectangle(
                        borderRadius: Radius.circular(18.r),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.contact_mail,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 20, // Consider .sp if needed
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          // Consider .sp if needed
                          'Created by Rana Ali',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        onTap: () {
                          LiquidSnackBar.show(
                            context,
                            message: "Contact action not implemented.",
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(authController).signout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 12.h,
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: Text('Log Out', style: TextStyle(fontSize: 18.sp)),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: AppLoader()),
              error: (e, st) => Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
