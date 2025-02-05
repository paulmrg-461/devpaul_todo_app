import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) =>
      NumberFormat.compactCurrency(
              decimalDigits: decimals, symbol: '', locale: 'en')
          .format(number);

  static String convertDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static String convertTime(DateTime date) => DateFormat('HH:mm').format(date);

  static String convertDateTime(DateTime date) =>
      DateFormat('yyyy-MM-dd HH:mm').format(date);

  static String getLastDayOfMonth(int year, int month) {
    DateTime nextMonth = DateTime(year, month + 1, 1);

    return DateFormat('yyyy-MM-dd')
        .format(nextMonth.subtract(const Duration(days: 1)));
  }

  static String convertCurrency(String value) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'es_MX', symbol: "\$", decimalDigits: 0);

    return formatter.format(int.parse(value));
  }

  static String formatWithThousandsSeparator(String number) {
    final numberFormat = double.tryParse(number) ?? 0;
    final NumberFormat formatter = NumberFormat('#,##0', 'es_ES');
    return formatter.format(numberFormat).replaceAll(',', '.');
  }

  static String compactNumber(double number, [int decimals = 0]) {
    final formatter = NumberFormat.compact(
      locale: 'en',
    );

    String formattedNumber = formatter.format(number);
    if (formattedNumber.contains(RegExp(r'[A-Za-z]$'))) {
      formattedNumber =
          formattedNumber.substring(0, formattedNumber.length - 1);
    }
    return formattedNumber;
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MM-yyyy').format(date);
  }
}
