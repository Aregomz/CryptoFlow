import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/coin_model.dart';

abstract class CryptocurrencyRemoteDataSource {
  Future<List<CoinModel>> getTopCoins({
    required String currency,
    required int perPage,
    required String order,
    required bool sparkline,
  });
  
  Future<CoinModel> getCoinDetails(String id);
}

class CryptocurrencyRemoteDataSourceImpl implements CryptocurrencyRemoteDataSource {
  final Dio dio;

  CryptocurrencyRemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
  }

  @override
  Future<List<CoinModel>> getTopCoins({
    required String currency,
    required int perPage,
    required String order,
    required bool sparkline,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.markets,
        queryParameters: {
          'vs_currency': currency,
          'order': order,
          'per_page': perPage,
          'sparkline': sparkline,
          'price_change_percentage': '24h',
        },
      );

      return (response.data as List)
          .map((coin) => CoinModel.fromJson(coin as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch coins: ${e.message}');
    }
  }

  @override
  Future<CoinModel> getCoinDetails(String id) async {
    try {
      final response = await dio.get(
        '${ApiConstants.coinDetail}/$id',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': true,
        },
      );

      return CoinModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch coin details: ${e.message}');
    }
  }
} 