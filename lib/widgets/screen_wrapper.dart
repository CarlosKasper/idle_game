import 'package:flutter/material.dart';
import 'ui_components.dart';

/// Widget que envolve as telas com a navegação inferior
class ScreenWrapper extends StatefulWidget {
  final Widget child;
  final int initialIndex;
  final Function(int) onNavigationChanged;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.initialIndex = 0,
    required this.onNavigationChanged,
  });

  @override
  State<ScreenWrapper> createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onNavigationChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        BottomNavigationMenu(
          selectedIndex: _selectedIndex,
          onItemTapped: _onNavItemTapped,
        ),
      ],
    );
  }
}
