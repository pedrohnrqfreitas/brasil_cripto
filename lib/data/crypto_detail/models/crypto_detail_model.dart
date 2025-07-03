
import '../entities/crypto_detail_entity.dart';

class CryptoDetailModel {
  final String id;
  final String symbol;
  final String name;
  final Map<String, dynamic> description;
  final Map<String, dynamic> image;
  final Map<String, dynamic> marketData;

  CryptoDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.image,
    required this.marketData,
  });

  factory CryptoDetailModel.fromJson(Map<String, dynamic> json) {
    return CryptoDetailModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? {},
      image: json['image'] ?? {},
      marketData: json['market_data'] ?? {},
    );
  }

  CryptoDetailEntity toEntity(List<List<double>> priceChart) {
    return CryptoDetailEntity(
      id: id,
      symbol: symbol,
      name: name,
      description: description['en'] ?? '',
      image: image['large'] ?? '',
      currentPrice: (marketData['current_price']?['usd'] ?? 0).toDouble(),
      priceChangePercentage24h: (marketData['price_change_percentage_24h'] ?? 0).toDouble(),
      priceChangePercentage7d: (marketData['price_change_percentage_7d'] ?? 0).toDouble(),
      priceChangePercentage30d: (marketData['price_change_percentage_30d'] ?? 0).toDouble(),
      marketCap: (marketData['market_cap']?['usd'] ?? 0).toDouble(),
      totalVolume: (marketData['total_volume']?['usd'] ?? 0).toDouble(),
      high24h: (marketData['high_24h']?['usd'] ?? 0).toDouble(),
      low24h: (marketData['low_24h']?['usd'] ?? 0).toDouble(),
      circulatingSupply: (marketData['circulating_supply'] ?? 0).toDouble(),
      totalSupply: marketData['total_supply']?.toDouble(),
      priceChart: priceChart,
    );
  }
}