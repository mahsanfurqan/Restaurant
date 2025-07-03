import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> persistentButtons;
  final double? height;

  const AppBottomSheet({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.persistentButtons = const [],
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Container(
      height: height,
      constraints: BoxConstraints(
        maxHeight: context.mediaQuerySize.height * .8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 30,
                    height: 4,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: (persistentButtons.isNotEmpty)
                          ? (context.mediaQueryViewPadding.bottom + 64)
                          : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: crossAxisAlignment,
                      mainAxisSize: mainAxisSize,
                      children: children,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: persistentButtons.isNotEmpty,
              child: Positioned(
                left: 0,
                bottom: 0,
                width: context.mediaQuerySize.width,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: colorScheme.surfaceContainerHighest,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: persistentButtons,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
