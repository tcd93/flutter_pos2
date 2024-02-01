import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_pos/pages/main_section/drawer/reports/report_1/report_one_chart.dart';
import 'package:flutter_pos/pages/main_section/drawer/reports/report_1/report_one_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
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
  late final RangeController sliderController;
  int year = DateTime.now().year;
  final title = ValueNotifier<String>('');

  // due to some weirdness in sfSlider's "divisions" calculation, we must set max to next year
  DateTime get max => DateTime(year + 1);
  DateTime get min => DateTime(year);

  @override
  Widget build(BuildContext context) {
    // get entire year's worth of transactions
    // maybe this will get slower if time goes on
    final transactions = ref
            .watch(priceByDateProvider(DateTimeRange(start: min, end: max)))
            .value ??
        [];

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
                  setTitle(SfRangeValues(min, max), title);
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
            // main chart
            Expanded(
              child: ReportOneChart(
                transactions: transactions,
                sliderController: sliderController,
              ),
            ),
            // slider
            ReportOneSlider(
              min: min,
              max: max,
              transactions: transactions,
              sliderController: sliderController,
              onRangeSelectorChanged: (range) {
                sliderController.start = range.start;
                // [SfRangeSelector]'s month interval requires the next month be greater than current month
                // we adjust this and set endDate of period back to end of current month
                if (isMonthSelection(range.start, range.end) ||
                    isYearSelection(range.start, range.end)) {
                  sliderController.end = (range.end as DateTime).add(
                    const Duration(days: -1),
                  );
                } else {
                  sliderController.end = range.end;
                }
                setTitle(range, title);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    sliderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    sliderController = RangeController(start: min, end: max);
    setTitle(SfRangeValues(min, max), title);
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

  void setTitle(SfRangeValues range, ValueNotifier<String> title) {
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
}
