import '../../domain/entities/coin.dart';

class CoinModel extends Coin {
  const CoinModel({
    required String id,
    required String symbol,
    required String name,
    required String image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    List<double>? sparklineData,
    bool isFavorite = false,
  }) : super(
          id: id,
          symbol: symbol,
          name: name,
          image: image,
          currentPrice: currentPrice,
          marketCap: marketCap,
          marketCapRank: marketCapRank,
          high24h: high24h,
          low24h: low24h,
          priceChange24h: priceChange24h,
          priceChangePercentage24h: priceChangePercentage24h,
          sparklineData: sparklineData,
          isFavorite: isFavorite,
        );

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
      high24h: (json['high_24h'] as num?)?.toDouble(),
      low24h: (json['low_24h'] as num?)?.toDouble(),
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble(),
      sparklineData: _extractSparklineData(json['sparkline_in_7d']),
    );
  }

  static List<double>? _extractSparklineData(dynamic sparklineData) {
    if (sparklineData == null || sparklineData['price'] == null) {
      return null;
    }
    
    try {
      final List<dynamic> prices = sparklineData['price'];
      return prices.map((price) => (price as num).toDouble()).toList();
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'sparkline_in_7d': sparklineData != null ? {'price': sparklineData} : null,
    };
  }
} 