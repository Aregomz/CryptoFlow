import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/coin.dart';
import '../../domain/repositories/cryptocurrency_repository.dart';
import '../datasources/cryptocurrency_remote_data_source.dart';

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
    if (await networkInfo.isConnected) {
      try {
        final coins = await remoteDataSource.getTopCoins(
          currency: currency,
          perPage: perPage,
          order: order,
          sparkline: sparkline,
        );
        return Right(coins);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Coin>> getCoinDetails(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final coin = await remoteDataSource.getCoinDetails(id);
        return Right(coin);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
} 