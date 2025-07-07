import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/pages/splash_page.dart';
import 'package:flutter_boilerplate/shared/utils/result_state/result_state.dart';
import 'package:flutter_boilerplate/modules/auth/data/models/auth_validate_model.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final authController = Get.find<AuthController>();
      final authState = authController.authState.value;

      print(
          'DEBUG: AuthMiddleware - Route: $route, AuthState: ${authState.runtimeType}');

      // If still loading, show splash
      if (authState is ResultLoading) {
        print('DEBUG: AuthMiddleware - Loading state, redirect to splash');
        return const RouteSettings(name: '/splash');
      }

      // If user is logged in
      if (authState is ResultSuccess<AuthValidateModel>) {
        print('DEBUG: AuthMiddleware - Success state, user logged in');
        // If trying to access auth pages, redirect to main
        if (route == AppRoutes.login ||
            route == AppRoutes.register ||
            route == '/splash') {
          print('DEBUG: AuthMiddleware - Redirecting logged in user to main');
          return const RouteSettings(name: AppRoutes.main);
        }
        return null; // Continue to requested page
      }

      // If user is not logged in
      if (authState is ResultFailed || authState is ResultInitial) {
        print(
            'DEBUG: AuthMiddleware - Failed/Initial state, user not logged in');
        // If trying to access protected pages, redirect to login
        if (route != AppRoutes.login &&
            route != AppRoutes.register &&
            route != '/splash') {
          print('DEBUG: AuthMiddleware - Redirecting to login');
          return const RouteSettings(name: AppRoutes.login);
        }
        return null; // Continue to requested page
      }

      print('DEBUG: AuthMiddleware - No redirect needed');
      return null;
    } catch (e) {
      print('DEBUG: AuthMiddleware - Exception: $e');
      // If there's an error, redirect to login
      return const RouteSettings(name: AppRoutes.login);
    }
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }
}
