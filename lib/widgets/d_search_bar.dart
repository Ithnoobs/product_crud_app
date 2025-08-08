import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;

  const CustomSearchBar({super.key, required this.onChanged, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        EasyDebounce.debounce('search_debounce', const Duration(milliseconds: 300), 
        () => onChanged(value)
        );
      },
    );
  }
}