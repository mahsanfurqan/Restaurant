import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/shared/styles/app_colors.dart';
import 'package:flutter_boilerplate/shared/styles/app_fonts.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    final authCtrl = Get.find<AuthController>();
    final state = authCtrl.authState.value;
    if (state is ResultSuccess<AuthValidateModel>) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Flutter Restaurant',
              style: AppFonts.xlBold.copyWith(
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: AppFonts.mdRegular.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
            ),
          ],
        ),
      ),
    );
  }
}
