import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';
import 'package:flutter_boilerplate/modules/note/presentation/widgets/note_tile.dart';
import 'package:flutter_boilerplate/shared/utils/app_fakes.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:flutter_boilerplate/shared/widgets/app_refresher.dart';
import 'package:flutter_boilerplate/shared/widgets/app_skeletonizer.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && result == true) {
          controller.onRefresh();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(AppLocalizations.notesTitle()),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorScheme.primary,
          onPressed: () {
            Get.toNamed(AppRoutes.noteForm);
          },
          child: Icon(
            Icons.add,
            color: colorScheme.onPrimary,
          ),
        ),
        body: SafeArea(
          child: AppRefresher(
            onRefresh: controller.onRefresh,
            onLoadMore: controller.onLoadMore,
            child: Obx(
              () => controller.notesState.value.when(
                loading: () {
                  return AppSkeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final note = AppFakes.note;
                        return NoteTile(
                          onTap: null,
                          note: note,
                        );
                      },
                    ),
                  );
                },
                success: (data) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final note = data[index];
                      return NoteTile(
                        onTap: () async {
                          final result = await Get.toNamed(
                            AppRoutes.noteDetail,
                            arguments: note.id,
                          ) as bool?;
                          if (result == true) {
                            final homeCtrl = Get.find<HomeController>();
                            homeCtrl.fetchNotes(refresh: true);
                          }
                        },
                        note: note,
                      );
                    },
                  );
                },
                failed: (message) {
                  return Center(
                    child: Text(message ?? ''),
                  );
                },
                initial: () {
                  return Center(
                    child: Text(
                      AppLocalizations.emptyNotesMessage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
