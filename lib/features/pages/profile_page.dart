import 'package:flutter/material.dart';
import 'package:dreamdwell/core/shared/widgets/custom_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const H2('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            H2('Your Profile'),
            SizedBox(height: 8),
            BodyText('Manage your account and preferences'),
          ],
        ),
      ),
    );
  }
}
