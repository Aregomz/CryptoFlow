import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final List<double> sparklineData;

  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.sparklineData,
  });

  @override
  List<Object> get props => [
        id,
        symbol,
        name,
        image,
        currentPrice,
        marketCap,
        marketCapRank,
        high24h,
        low24h,
        priceChange24h,
        priceChangePercentage24h,
        sparklineData,
      ];
} 