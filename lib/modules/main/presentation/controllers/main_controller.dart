import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final currentPage = 0.obs;
  final pageCtrl = PageController();

  void changePage(int index) {
    print('Change page to $index');
    currentPage.value = index;
    pageCtrl.jumpToPage(index);
  }
}
