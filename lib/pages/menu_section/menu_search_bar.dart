import 'package:flutter/material.dart';
import 'package:flutter_pos/widgets/anim_search_widget.dart';

class MenuSearchBar extends StatelessWidget {
  final ValueNotifier<String> filterString;

  const MenuSearchBar(this.filterString, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 200),
      child: AnimatedSearchBar(
        searchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          label: Text('Search', textScaler: TextScaler.linear(0.75)),
          labelStyle: TextStyle(fontWeight: FontWeight.w300),
          filled: true,
          fillColor: Theme.of(context).dialogBackgroundColor.withOpacity(0.4),
          isDense: true,
        ),
        searchIcon: Icon(
          Icons.search,
          key: ValueKey('open'),
          color: Theme.of(context).colorScheme.primary,
        ),
        closeIcon: Icon(
          Icons.close,
          key: ValueKey('close'),
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (filter) {
          filterString.value = filter;
        },
      ),
    );
  }
}
