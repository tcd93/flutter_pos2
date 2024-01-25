import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:flutter_pos/pages/main_section/page_view/collapsible_card/collapsible_card_header.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/widgets/flat_collapsible_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'collapsible_card_details.dart';

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
  late AnimationController controller;
  bool expanded = false;

  // keepAlive this state to not reset animation controller upon
  // switching page view
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FlatCollapsibleCard(
      controller: controller,
      header: CollapsibleCardHeader(
        cardID: widget.cardID,
        pageID: widget.pageID,
        animation: controller,
      ),
      details: CollapsibleCardDetails(
        cardID: widget.cardID,
        openContainer: widget.openContainer,
      ),
      onToggle: (expanded) {
        expanded ? controller.reverse() : controller.forward();
        this.expanded = expanded;
      },
      beginHeightFactor: AppTheme.beginHeightFactor,
      beginWidthFactor: AppTheme.beginWidthFactor,
      endHeightFactor: AppTheme.endHeightFactor,
      endWidthFactor: AppTheme.endWidthFactor,
      maxHeight: AppTheme.cardHeightMax,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: AppTheme.cardExpandDuration),
    );

    ref.listenManual(pageStatusProvider, (previous, next) {
      if (previous?.selected == widget.pageID) {
        controller.reverse();
      }
      if (this.expanded && next.selected == widget.pageID) {
        controller.forward();
      }
    });
    super.initState();
  }
}
