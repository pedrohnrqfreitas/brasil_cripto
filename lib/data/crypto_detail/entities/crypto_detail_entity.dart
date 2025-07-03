import 'package:equatable/equatable.dart';

class CryptoDetailEntity extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String description;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double priceChangePercentage7d;
  final double priceChangePercentage30d;
  final double marketCap;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double circulatingSupply;
  final double? totalSupply;
  final List<List<double>> priceChart;

  const CryptoDetailEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.priceChangePercentage7d,
    required this.priceChangePercentage30d,
    required this.marketCap,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
    this.totalSupply,
    required this.priceChart,
  });

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    description,
    image,
    currentPrice,
    priceChangePercentage24h,
    priceChangePercentage7d,
    priceChangePercentage30d,
    marketCap,
    totalVolume,
    high24h,
    low24h,
    circulatingSupply,
    totalSupply,
    priceChart,
  ];
}