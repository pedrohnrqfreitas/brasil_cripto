import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _brazilianReal = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  );

  static final _usDollar = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  );

  static final _compact = NumberFormat.compact(locale: 'pt_BR');

  /// Formata valor em Real Brasileiro
  static String formatBRL(double value) {
    return _brazilianReal.format(value);
  }

  /// Formata valor em Dólar Americano
  static String formatUSD(double value) {
    return _usDollar.format(value);
  }

  /// Formata valor de forma compacta (ex: 1.5M, 2.3B)
  static String formatCompact(double value) {
    return _compact.format(value);
  }

  /// Formata porcentagem com sinal
  static String formatPercentage(double value, {int decimals = 2}) {
    final isPositive = value >= 0;
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: decimals,
    );

    final formatted = formatter.format(value.abs());
    return '${isPositive ? '+' : '-'}$formatted%';
  }
}