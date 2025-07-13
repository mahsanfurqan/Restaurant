import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/auth/presentation/controllers/auth_controller.dart';
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
      if (authState is ResultLoading) {
        print('DEBUG: AuthMiddleware - Loading state, redirect to splash');
        return const RouteSettings(name: '/splash');
      }

      if (authState is ResultSuccess<AuthValidateModel>) {
        print('DEBUG: AuthMiddleware - Success state, user logged in');
        if (route == AppRoutes.login ||
            route == AppRoutes.register ||
            route == '/splash') {
          print('DEBUG: AuthMiddleware - Redirecting logged in user to main');
          return const RouteSettings(name: AppRoutes.main);
        }
        return null;
      }

      if (authState is ResultFailed || authState is ResultInitial) {
        print(
            'DEBUG: AuthMiddleware - Failed/Initial state, user not logged in');
        if (route != AppRoutes.login &&
            route != AppRoutes.register &&
            route != '/splash') {
          print('DEBUG: AuthMiddleware - Redirecting to login');
          return const RouteSettings(name: AppRoutes.login);
        }
        return null;
      }

      print('DEBUG: AuthMiddleware - No redirect needed');
      return null;
    } catch (e) {
      print('DEBUG: AuthMiddleware - Exception: $e');
      return const RouteSettings(name: AppRoutes.login);
    }
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }
}
