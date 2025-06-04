import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/coin.dart';

abstract class CryptocurrencyRepository {
  Future<Either<Failure, List<Coin>>> getTopCoins({
    required String currency,
    required int perPage,
    required String order,
    required bool sparkline,
  });
  
  Future<Either<Failure, Coin>> getCoinDetails(String id);
} 