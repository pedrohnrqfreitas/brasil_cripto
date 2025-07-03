import 'package:equatable/equatable.dart';

class CryptoEntity extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final double totalVolume;
  final List<double> sparklineIn7d;
  final bool isFavorite;

  const CryptoEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.totalVolume,
    required this.sparklineIn7d,
    this.isFavorite = false,
  });

  CryptoEntity copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? priceChangePercentage24h,
    double? marketCap,
    double? totalVolume,
    List<double>? sparklineIn7d,
    bool? isFavorite,
  }) {
    return CryptoEntity(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      totalVolume: totalVolume ?? this.totalVolume,
      sparklineIn7d: sparklineIn7d ?? this.sparklineIn7d,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    image,
    currentPrice,
    priceChangePercentage24h,
    marketCap,
    totalVolume,
    sparklineIn7d,
    isFavorite,
  ];
}