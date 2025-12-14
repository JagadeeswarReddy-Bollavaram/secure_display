import 'package:flutter/material.dart';

/// Reusable profile icon button widget
class ProfileIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileIconButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: onPressed,
      tooltip: 'Profile',
    );
  }
}


