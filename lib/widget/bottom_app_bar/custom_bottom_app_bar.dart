import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onTap;
  const CustomBottomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Log',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.kitchen_outlined,
          ),
          label: 'Food',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.scale_outlined,
          ),
          label: 'Weight',
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
    );
  }
}
