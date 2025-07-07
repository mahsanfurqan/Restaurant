import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/utils/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_boilerplate/core/routes/app_pages.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const CustomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 32,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavbarButton(
                icon: Icons.menu,
                label: AppLocalizations.menu(),
                isActive: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavbarButton(
                icon: Icons.settings,
                label: AppLocalizations.settings(),
                isActive: selectedIndex == 1,
                onTap: () => Get.toNamed(AppRoutes.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavbarButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00BFA5) : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF00BFA5),
                size: 28,
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
