// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinModel _$CoinModelFromJson(Map<String, dynamic> json) => CoinModel(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  currentPrice: (json['currentPrice'] as num).toDouble(),
  marketCap: (json['marketCap'] as num).toDouble(),
  marketCapRank: (json['marketCapRank'] as num).toInt(),
  high24h: (json['high24h'] as num).toDouble(),
  low24h: (json['low24h'] as num).toDouble(),
  priceChange24h: (json['priceChange24h'] as num).toDouble(),
  priceChangePercentage24h:
      (json['priceChangePercentage24h'] as num).toDouble(),
  sparklineData:
      (json['sparklineData'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
);

Map<String, dynamic> _$CoinModelToJson(CoinModel instance) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'name': instance.name,
  'image': instance.image,
  'currentPrice': instance.currentPrice,
  'marketCap': instance.marketCap,
  'marketCapRank': instance.marketCapRank,
  'high24h': instance.high24h,
  'low24h': instance.low24h,
  'priceChange24h': instance.priceChange24h,
  'priceChangePercentage24h': instance.priceChangePercentage24h,
  'sparklineData': instance.sparklineData,
};
