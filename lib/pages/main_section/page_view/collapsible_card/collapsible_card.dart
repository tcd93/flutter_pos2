import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_details.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_header.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/widgets/flat_collapsible_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class CollapsibleCard extends ConsumerStatefulWidget {
  final int cardID;
  final int pageID;
  final VoidCallback openContainer;

  const CollapsibleCard({
    required this.cardID,
    required this.pageID,
    required this.openContainer,
    super.key,
  });

  @override
  ConsumerState<CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends ConsumerState<CollapsibleCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final _logger = Logger('CollapsibleCard ${widget.cardID}');
  late AnimationController controller;

  bool expanded = false;

  // keepAlive this state to not reset animation controller upon
  // switching page view
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return FlatCollapsibleCard(
      header: CollapsibleCardHeader(
        cardID: widget.cardID,
        pageID: widget.pageID,
        animation: controller,
      ),
      details: CollapsibleCardDetails(
        cardID: widget.cardID,
        openContainer: widget.openContainer,
      ),
      onToggle: () {
        expanded ? controller.reverse() : controller.forward();
        expanded = !expanded;
      },
      animatableHeight: Tween<double>(
        begin: AppTheme.beginHeightFactor * AppTheme.cardHeightMax,
        end: AppTheme.endHeightFactor * AppTheme.cardHeightMax,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(controller),
      animatableWidth: Tween<double>(
        begin: AppTheme.beginWidthFactor * screenWidth,
        end: AppTheme.endWidthFactor * screenWidth,
      ).chain(CurveTween(curve: Curves.easeOutBack)).animate(controller),
    );
  }

  @override
  void dispose() {
    _logger.info('Disposed');
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppTheme.cardExpandDuration),
    );

    ref.listenManual(pageStatusProvider, (previous, next) {
      if (previous?.selected == widget.pageID) {
        // _logger.info('controller.reverse()');
        controller.reverse();
      }
      if (expanded && next.selected == widget.pageID) {
        // _logger.info('controller.forward()');
        controller.forward();
      }
    });
    super.initState();
  }
}
