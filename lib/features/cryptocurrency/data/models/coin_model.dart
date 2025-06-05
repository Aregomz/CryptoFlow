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
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    List<double>? sparklineData,
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