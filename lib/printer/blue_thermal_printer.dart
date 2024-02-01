import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter_pos/pages/data/repos/line_item.dart';
import 'package:flutter_pos/pages/main_section/common/extension/discount_rate_ext.dart';
import 'package:flutter_pos/utils/money.dart';

class Printer {
  Printer._();

  static List<BluetoothDevice>? _bondedDevices;

  static late BluetoothDevice _device;

  static BlueThermalPrinter get instance => BlueThermalPrinter.instance;

  static Future<void> print({
    required DateTime checkoutTime,
    required List<LineItem> lineItems,
    required double originalPrice,
    required double discountRate,
    required double customerPayAmount,
  }) async {
    if (_bondedDevices == null || _bondedDevices!.isEmpty) {
      _bondedDevices = await instance.getBondedDevices();
      if (_bondedDevices!.isEmpty) {
        throw 'No bluetooth devices!';
      }
    }

    var isConnected = await instance.isConnected;
    if (isConnected != null && !isConnected) {
      _device = _bondedDevices![0];
      await instance.connect(_device);
    }
    if (lineItems.isEmpty) {
      throw 'print error: empty order';
    }

    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    await instance.printCustom('RECEIPT', 3, 1);
    await instance.printCustom(formatDate(checkoutTime.toLocal()), 0, 1);
    await instance.printCustom('---------', 1, 1);
    for (final i in lineItems) {
      await instance.printLeftRight(
        '${i.dishName}(${i.quantity})',
        Money.format(i.quantity * i.price),
        0,
      );
    }
    await instance.printLeftRight('', '---------', 0);
    if (discountRate < 1.0) {
      await instance.printLeftRight('', Money.format(originalPrice), 1);
      await instance.printLeftRight(
          'Discount:', discountRate.toPercentStr(), 0);
    }
    final total = (originalPrice * discountRate).round();
    await instance.printLeftRight('Total', Money.format(total), 2);
    await instance.printLeftRight('Paid', Money.format(customerPayAmount), 0);
    if (customerPayAmount > total) {
      await instance.printLeftRight(
          'Change', Money.format(customerPayAmount - total), 1);
    }
    await instance.printCustom('Thank you', 2, 1);
    await instance.printNewLine();
    await instance.printNewLine();
    await instance.printNewLine();
    await instance.paperCut();
  }
}

// yyyy-mm-dd H:i:s
String formatDate(DateTime date) {
  return date.toString().substring(0, 19);
}
