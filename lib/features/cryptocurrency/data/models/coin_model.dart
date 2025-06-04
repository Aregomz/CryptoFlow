import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/coin.dart';

part 'coin_model.g.dart';

@JsonSerializable()
class CoinModel extends Coin {
  const CoinModel({
    required String id,
    required String symbol,
    required String name,
    required String image,
    required double currentPrice,
    required double marketCap,
    required int marketCapRank,
    required double high24h,
    required double low24h,
    required double priceChange24h,
    required double priceChangePercentage24h,
    required List<double> sparklineData,
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
        );

  factory CoinModel.fromJson(Map<String, dynamic> json) => _$CoinModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoinModelToJson(this);
} 