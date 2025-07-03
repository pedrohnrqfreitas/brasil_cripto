import '../entities/crypto_entity.dart';

class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final Map<String, dynamic>? sparklineIn7d;

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    this.sparklineIn7d,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      totalVolume: (json['total_volume'] ?? 0).toDouble(),
      sparklineIn7d: json['sparkline_in_7d'],
    );
  }

  CryptoEntity toEntity() {
    // A API do CoinGecko retorna sparkline_in_7d como um objeto com a chave 'price'
    // que contém um array de valores numéricos representando o preço nos últimos 7 dias
    List<double> sparkline = [];

    // Verificar se sparklineIn7d existe e tem a estrutura esperada
    if (sparklineIn7d != null && sparklineIn7d is Map) {
      // Acessar o array 'price' dentro do objeto sparklineIn7d
      final priceList = sparklineIn7d!['price'];

      if (priceList != null && priceList is List) {
        sparkline = priceList
            .map((price) => price is num ? price.toDouble() : 0.0)
            .toList();
      }
    }

    return CryptoEntity(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      priceChangePercentage24h: priceChangePercentage24h,
      marketCap: marketCap,
      totalVolume: totalVolume,
      sparklineIn7d: sparkline,
    );
  }
}
