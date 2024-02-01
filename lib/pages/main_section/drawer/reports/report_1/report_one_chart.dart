import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

final _logger = Logger('Report 1 Chart');

class ReportOneChart extends ConsumerWidget {
  final List<GetPriceByDateResult> transactions;

  final RangeController sliderController;

  const ReportOneChart({
    super.key,
    required this.transactions,
    required this.sliderController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: sliderController,
      builder: (context, series) {
        _logger.info('_Chart Slider: $sliderController');
        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          enableAxisAnimation: true,
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: DateTimeAxis(
            isVisible: false,
            minimum: sliderController.start,
            maximum: sliderController.end,
            dateFormat: DateFormat.MMMMd(),
          ),
          primaryYAxis: const NumericAxis(
            labelPosition: ChartDataLabelPosition.outside,
            labelAlignment: LabelAlignment.end,
            majorTickLines: MajorTickLines(size: 0),
            axisLine: AxisLine(color: Colors.transparent),
            anchorRangeToVisiblePoints: false,
          ),
          series: [
            series as SplineSeries,
          ],
        );
      },
      child: SplineSeries<GetPriceByDateResult, DateTime>(
        dataSource: transactions,
        name: '',
        xValueMapper: (sale, _) => sale.date,
        yValueMapper: (sale, _) => sale.priceByDate,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 0.8,
        markerSettings: const MarkerSettings(isVisible: true),
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.hide,
        ),
        animationDuration: 0,
      ),
    );
  }
}
