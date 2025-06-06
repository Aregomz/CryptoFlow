import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/coin_model.dart';
import '../../domain/entities/coin.dart';
import 'dart:developer' as dev;

abstract class CryptocurrencyRemoteDataSource {
  Future<List<Coin>> getTopCoins({
    String currency = 'usd',
    int perPage = 100,
    String order = 'market_cap_desc',
    bool sparkline = true,
  });
  
  Future<CoinModel> getCoinDetails(String id);
}

class CryptocurrencyRemoteDataSourceImpl implements CryptocurrencyRemoteDataSource {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';
  final String _apiKey = 'CG-MMShMpAUsU28JXzVfCWBDjyE';

  CryptocurrencyRemoteDataSourceImpl();

  @override
  Future<List<Coin>> getTopCoins({
    String currency = 'usd',
    int perPage = 100,
    String order = 'market_cap_desc',
    bool sparkline = true,
  }) async {
    try {
      dev.log('Fetching top coins...');
      dev.log('API Key: $_apiKey');

      final response = await http.get(
        Uri.parse('$_baseUrl/coins/markets?vs_currency=$currency&per_page=$perPage&order=$order&sparkline=true&price_change_percentage=24h'),
        headers: {
          'x-cg-demo-api-key': _apiKey,
        },
      );

      dev.log('API Response Status Code: ${response.statusCode}');
      dev.log('API Response Headers: ${response.headers}');
      dev.log('API Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final coins = data.map((json) => _mapJsonToCoin(json)).toList();
        dev.log('Successfully processed ${coins.length} coins');
        return coins;
      } else {
        dev.log('ERROR: API response status code: ${response.statusCode}');
        throw Exception('Failed to load coins');
      }
    } catch (e) {
      dev.log('Error occurred while fetching coins: $e');
      throw Exception('Failed to load coins: $e');
    }
  }

  CoinModel _mapJsonToCoin(dynamic json) {
    dev.log('Processing coin data:');
    dev.log('ID: ${json['id']}');
    dev.log('Symbol: ${json['symbol']}');
    dev.log('Current Price: ${json['current_price']}');
    dev.log('Price Change 24h: ${json['price_change_percentage_24h']}');
    
    return CoinModel.fromJson(json);
  }

  List<double>? _extractSparklineData(dynamic sparklineData) {
    if (sparklineData == null || sparklineData['price'] == null) {
      return null;
    }
    
    try {
      final List<dynamic> prices = sparklineData['price'];
      return prices.map((price) => (price as num).toDouble()).toList();
    } catch (e) {
      dev.log('Error extracting sparkline data: $e');
      return null;
    }
  }

  @override
  Future<CoinModel> getCoinDetails(String id) async {
    try {
      dev.log('Fetching details for coin: $id');
      dev.log('API Key: $_apiKey');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/$id'),
        headers: {
          'x-cg-demo-api-key': _apiKey,
        },
      );

      dev.log('API Response Status Code: ${response.statusCode}');
      dev.log('API Response Headers: ${response.headers}');
      dev.log('API Raw Response for $id: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final marketData = data['market_data'] as Map<String, dynamic>?;
        
        if (marketData == null) {
          throw Exception('No market data available');
        }

        dev.log('Market data for $id:');
        dev.log('Current price USD: ${marketData['current_price']?['usd']}');
        dev.log('Price change 24h: ${marketData['price_change_percentage_24h']}');
        dev.log('Sparkline data available: ${marketData['sparkline_7d'] != null}');

        return CoinModel(
          id: data['id'],
          symbol: data['symbol'],
          name: data['name'],
          image: data['image']['large'],
          currentPrice: (marketData['current_price']?['usd'] as num?)?.toDouble(),
          marketCap: (marketData['market_cap']?['usd'] as num?)?.toDouble(),
          marketCapRank: (data['market_cap_rank'] as num?)?.toInt(),
          high24h: (marketData['high_24h']?['usd'] as num?)?.toDouble(),
          low24h: (marketData['low_24h']?['usd'] as num?)?.toDouble(),
          priceChange24h: (marketData['price_change_24h'] as num?)?.toDouble(),
          priceChangePercentage24h: (marketData['price_change_percentage_24h'] as num?)?.toDouble(),
          sparklineData: _extractSparklineData(marketData['sparkline_7d']),
        );
      } else {
        dev.log('ERROR: API response status code: ${response.statusCode}');
        throw Exception('Failed to load coin details');
      }
    } catch (e) {
      dev.log('Error occurred while fetching coin $id: $e');
      throw Exception('Failed to load coin details: $e');
    }
  }
} 