import 'package:intl/intl.dart';
import '../utils/constants.dart';

class AppHelpers {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: AppConstants.defaultCurrency,
    ).format(amount);
  }
}
