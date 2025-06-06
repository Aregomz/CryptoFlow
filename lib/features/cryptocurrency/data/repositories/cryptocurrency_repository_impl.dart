import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/coin.dart';
import '../../domain/repositories/cryptocurrency_repository.dart';
import '../datasources/cryptocurrency_remote_data_source.dart';
import 'dart:developer' as dev;

class CryptocurrencyRepositoryImpl implements CryptocurrencyRepository {
  final CryptocurrencyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CryptocurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Coin>>> getTopCoins({
    required String currency,
    required int perPage,
    required String order,
    required bool sparkline,
  }) async {
    dev.log('Repository: Getting top coins');
    dev.log('Parameters - currency: $currency, perPage: $perPage, order: $order, sparkline: $sparkline');

    if (await networkInfo.isConnected) {
      try {
        dev.log('Network is connected, fetching from remote data source');
        final coins = await remoteDataSource.getTopCoins(
          currency: currency,
          perPage: perPage,
          order: order,
          sparkline: sparkline,
        );

        dev.log('Successfully fetched ${coins.length} coins');
        for (var coin in coins) {
          dev.log('Coin ${coin.name}:');
          dev.log('Current Price: ${coin.currentPrice}');
          dev.log('Price Change 24h: ${coin.priceChange24h}');
          dev.log('Price Change Percentage 24h: ${coin.priceChangePercentage24h}');
        }

        return Right(coins);
      } catch (e) {
        dev.log('Error fetching coins: $e');
        return Left(ServerFailure(e.toString()));
      }
    } else {
      dev.log('No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Coin>> getCoinDetails(String id) async {
    dev.log('Repository: Getting details for coin $id');

    if (await networkInfo.isConnected) {
      try {
        dev.log('Network is connected, fetching coin details from remote data source');
        final coin = await remoteDataSource.getCoinDetails(id);

        dev.log('Successfully fetched details for ${coin.name}:');
        dev.log('Current Price: ${coin.currentPrice}');
        dev.log('Price Change 24h: ${coin.priceChange24h}');
        dev.log('Price Change Percentage 24h: ${coin.priceChangePercentage24h}');

        return Right(coin);
      } catch (e) {
        dev.log('Error fetching coin details: $e');
        return Left(ServerFailure(e.toString()));
      }
    } else {
      dev.log('No internet connection');
      return const Left(NetworkFailure('No internet connection'));
    }
  }
} 