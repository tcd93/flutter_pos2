import 'package:flutter/material.dart';
import 'package:flutter_pos/widgets/anim_search_widget.dart';

class MySearchBar extends StatelessWidget {
  final ValueNotifier<String> filterString;

  const MySearchBar(this.filterString, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 64.0;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: screenWidth),
      child: AnimatedSearchBar(
        searchDecoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          label: const Text('Search', textScaler: TextScaler.linear(0.75)),
          labelStyle: const TextStyle(fontWeight: FontWeight.w300),
          filled: true,
          fillColor: Theme.of(context).dialogBackgroundColor.withOpacity(0.4),
          isDense: true,
        ),
        searchIcon: Icon(
          Icons.search,
          key: const ValueKey('open'),
          color: Theme.of(context).colorScheme.primary,
        ),
        closeIcon: Icon(
          Icons.close,
          key: const ValueKey('close'),
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (filter) {
          filterString.value = filter;
        },
      ),
    );
  }
}
