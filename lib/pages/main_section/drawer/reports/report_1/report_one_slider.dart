import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ReportOneSlider extends ConsumerWidget {
  // display ranges
  final DateTime min;
  final DateTime max;

  final List<GetPriceByDateResult> transactions;

  final RangeController sliderController;

  final void Function(SfRangeValues range) onRangeSelectorChanged;

  const ReportOneSlider({
    super.key,
    required this.min,
    required this.max,
    required this.transactions,
    required this.sliderController,
    required this.onRangeSelectorChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQueryData = MediaQuery.of(context);
    return SfRangeSelector(
      min: min,
      max: max,
      interval: 1,
      controller: sliderController,
      onChanged: onRangeSelectorChanged,
      labelPlacement: LabelPlacement.betweenTicks,
      dateIntervalType: DateIntervalType.months,
      initialValues: SfRangeValues(min, max),
      showTicks: true,
      showLabels: true,
      dragMode: SliderDragMode.both,
      enableIntervalSelection: true,
      labelFormatterCallback: (dynamic actualLabel, String formattedText) {
        String label = DateFormat.MMM().format(actualLabel);
        label = mediaQueryData.size.width <= 1000 ? label[0] : label;
        return label;
      },
      // enableTooltip: true,
      // shouldAlwaysShowTooltip: true,
      dateFormat: DateFormat.MMM(),
      child: Container(
        height: 75,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        color: Theme.of(context).focusColor,
        child: SfCartesianChart(
          margin: EdgeInsets.zero,
          primaryXAxis: DateTimeAxis(
            isVisible: false,
            minimum: min,
            maximum: max,
          ),
          primaryYAxis: const NumericAxis(isVisible: false),
          plotAreaBorderWidth: 0,
          series: [
            SplineAreaSeries<GetPriceByDateResult, DateTime>(
              dataSource: transactions,
              borderDrawMode: BorderDrawMode.excludeBottom,
              xValueMapper: (sale, _) => sale.date,
              yValueMapper: (sale, _) => sale.priceByDate,
            )
          ],
        ),
      ),
    );
  }
}
