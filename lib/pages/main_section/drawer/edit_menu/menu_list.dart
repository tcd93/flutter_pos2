import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Menu List');

// page 0

class MenuList extends ConsumerWidget {
  final PageController pageControl;

  const MenuList(this.pageControl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dishIDProvider);

    return asyncData.when(
      data: (dishIDs) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              key: ValueKey(index),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(index.toString()),
                onTap: () {
                  pageControl.animateToPage(
                    1,
                    duration: const Duration(
                      milliseconds: AppTheme.carouselDuration,
                    ),
                    curve: Curves.easeIn,
                  );
                },
              ),
            );
          },
          itemCount: dishIDs.length,
          itemExtent: 100,
          physics: const BouncingScrollPhysics(),
        );
      },
      error: (error, stackTrace) {
        _logger.severe('Error', error, stackTrace);
        return const Center(child: Text('An error occurred'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
