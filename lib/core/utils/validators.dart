class Validators {
  /// Valida se uma string é um número válido
  static bool isValidNumber(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value.replaceAll(',', '.')) != null;
  }

  /// Valida se um símbolo de crypto é válido (3-5 caracteres)
  static bool isValidCryptoSymbol(String symbol) {
    if (symbol.isEmpty) return false;
    final regex = RegExp(r'^[A-Z]{2,5}$');
    return regex.hasMatch(symbol.toUpperCase());
  }

  /// Remove caracteres especiais para busca
  static String sanitizeSearchQuery(String query) {
    return query
        .trim()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .toLowerCase();
  }
}