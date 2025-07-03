import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/shared/widgets/custom_navbar.dart';

class LihatMenuPage extends StatelessWidget {
  const LihatMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Menu'),
      ),
      body: const Center(
        child: Text('Halaman Lihat Menu'),
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 0,
        onTap: (index) {
          // TODO: Implement navigation if needed
        },
      ),
    );
  }
}
