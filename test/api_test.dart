import 'package:dio/dio.dart';
import 'dart:developer' as dev;

void main() async {
  final dio = Dio();
  const apiKey = 'CG-MMShMpAUsU28JXzVfCWBDjyE';
  
  dio.options.headers = {
    'x-cg-demo-api-key': apiKey,
  };

  try {
    print('Testing CoinGecko API...');
    print('Using API Key: $apiKey');

    // Test markets endpoint
    final marketsResponse = await dio.get(
      'https://api.coingecko.com/api/v3/coins/markets',
      queryParameters: {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': 10,
        'sparkline': true,
        'price_change_percentage': '24h',
      },
    );

    print('\nMarkets Response Status: ${marketsResponse.statusCode}');
    print('Markets Response Headers: ${marketsResponse.headers}');
    
    if (marketsResponse.statusCode == 200) {
      final List<dynamic> coins = marketsResponse.data;
      print('\nFirst coin data:');
      final firstCoin = coins.first;
      print('ID: ${firstCoin['id']}');
      print('Name: ${firstCoin['name']}');
      print('Current Price: ${firstCoin['current_price']}');
      print('Price Change 24h: ${firstCoin['price_change_24h']}');
      print('Price Change Percentage 24h: ${firstCoin['price_change_percentage_24h']}');
    } else {
      print('Error response: ${marketsResponse.data}');
    }

  } catch (e) {
    if (e is DioException) {
      print('DioError occurred:');
      print('Error message: ${e.message}');
      print('Error type: ${e.type}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
    } else {
      print('Error occurred: $e');
    }
  }
} 