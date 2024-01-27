import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Renders the range selector with line chart zooming option
class ReportView extends ConsumerStatefulWidget {
  /// Renders the range selector with line chart zooming option
  const ReportView({super.key});

  @override
  createState() => _ReportState();
}

class _ReportState extends ConsumerState<ReportView> {
  final currentYear = DateTime.now().year;
  late final RangeController rangeController;
  late final RangeController sliderController;
  int year = DateTime.now().year;
  var title = ValueNotifier<String>('');

  // due to some weirdness in sfSlider's "divisions" calculation, we must set max to next year
  DateTime get max => DateTime(year + 1);
  DateTime get min => DateTime(year);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              focusColor: Colors.transparent,
              isDense: true,
              value: year,
              items: [
                for (int i = 0; i < 5; i++)
                  DropdownMenuItem(
                    value: currentYear - i,
                    child: Text((currentYear - i).toString()),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => year = value);
                  setTitle(SfRangeValues(min, max));
                  sliderController.start = min;
                  sliderController.end = max;
                }
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: title,
              builder: (context, title, _) => Text(title),
            ),
            const SizedBox(height: 10),
            Expanded(child: chart()),
            slider(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget chart() {
    final transactions = ref
        .watch(priceByDateProvider(DateTimeRange(start: min, end: max)))
        .value;
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: DateTimeAxis(
        isVisible: false,
        initialVisibleMinimum: rangeController.start,
        initialVisibleMaximum: rangeController.end,
        rangeController: rangeController,
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
        SplineSeries<({DateTime dateTime, double? price}), DateTime>(
          dataSource: transactions ?? [],
          name: '',
          xValueMapper: (sale, _) => sale.dateTime,
          yValueMapper: (sale, _) => sale.price,
          splineType: SplineType.cardinal,
          cardinalSplineTension: 0.8,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelIntersectAction: LabelIntersectAction.hide,
          ),
          animationDuration: 0,
        ),
      ],
    );
  }

  @override
  void dispose() {
    rangeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rangeController = RangeController(start: min, end: max);
    sliderController = RangeController(start: min, end: max);
    setTitle(SfRangeValues(min, max));
    super.initState();
  }

  bool isMonthSelection(DateTime startDt, DateTime endDt) {
    return (endDt == DateUtils.addMonthsToMonthDate(startDt, 1)) &&
        startDt.day == 1 &&
        endDt.day == 1;
  }

  bool isYearSelection(DateTime startDt, DateTime endDt) {
    return (endDt.year - startDt.year == 1 &&
            startDt.month == 1 &&
            endDt.month == 1) &&
        startDt.day == 1 &&
        endDt.day == 1;
  }

  void setTitle(SfRangeValues range) {
    final startDt = range.start as DateTime;
    final endDt = range.end as DateTime;
    if (isMonthSelection(startDt, endDt)) {
      title.value = 'Transactions of ${DateFormat.yMMMM().format(range.start)}';
      return;
    }
    if (isYearSelection(startDt, endDt)) {
      title.value = 'Transactions of ${DateFormat.y().format(range.start)}';
      return;
    }
    final start = DateFormat.yMMMd().format(range.start);
    final end = DateFormat.yMMMd().format(range.end);
    title.value = 'Transactions from $start to $end';
  }

  Widget slider(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final transactions = ref
        .watch(priceByDateProvider(DateTimeRange(start: min, end: max)))
        .value;
    return SfRangeSelector(
      min: min,
      max: max,
      interval: 1,
      controller: sliderController,
      onChanged: (range) {
        rangeController.start = range.start;
        // [SfRangeSelector]'s month interval requires the next month be greater than current month
        // we adjust this and set endDate of period back to end of current month
        if (isMonthSelection(range.start, range.end) ||
            isYearSelection(range.start, range.end)) {
          rangeController.end = (range.end as DateTime).add(
            const Duration(days: -1),
          );
        } else {
          rangeController.end = range.end;
        }
        setTitle(range);
      },
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
            SplineAreaSeries<({DateTime dateTime, double? price}), DateTime>(
              dataSource: transactions ?? [],
              borderDrawMode: BorderDrawMode.excludeBottom,
              xValueMapper: (sale, index) => sale.dateTime,
              yValueMapper: (sale, _) => sale.price,
            )
          ],
        ),
      ),
    );
  }
}
