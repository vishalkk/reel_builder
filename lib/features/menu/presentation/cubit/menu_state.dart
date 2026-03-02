import 'package:flutter/material.dart';

class MenuState {
  final Map<String, IconData> items;
  final String? selectedRoute;

  MenuState({required this.items, this.selectedRoute});

  MenuState copyWith({Map<String, IconData>? items, String? selectedRoute}) {
    return MenuState(
      items: items ?? this.items,
      selectedRoute: selectedRoute,
    );
  }
}
