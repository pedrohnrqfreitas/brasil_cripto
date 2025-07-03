import 'package:intl/intl.dart';

/// Classe utilitária para formatação de datas
class DateFormatter {
  static final _fullDate = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _shortDate = DateFormat('dd/MM', 'pt_BR');
  static final _fullDateTime = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
  static final _timeOnly = DateFormat('HH:mm', 'pt_BR');
  static final _monthYear = DateFormat('MMMM yyyy', 'pt_BR');

  /// Formata data completa (dd/MM/yyyy)
  static String formatFullDate(DateTime date) {
    return _fullDate.format(date);
  }

  /// Formata data curta (dd/MM)
  static String formatShortDate(DateTime date) {
    return _shortDate.format(date);
  }

  /// Formata data e hora (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime date) {
    return _fullDateTime.format(date);
  }

  /// Formata apenas hora (HH:mm)
  static String formatTime(DateTime date) {
    return _timeOnly.format(date);
  }

  /// Formata mês e ano (Janeiro 2024)
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }

  /// Retorna texto relativo ao tempo (ex: "há 2 horas")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatFullDate(date);
    } else if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora mesmo';
    }
  }
}