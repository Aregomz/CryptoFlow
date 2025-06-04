import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/coin.dart';
import '../../domain/repositories/cryptocurrency_repository.dart';
import '../../../../core/constants/api_constants.dart';

part 'cryptocurrency_event.dart';
part 'cryptocurrency_state.dart';

class CryptocurrencyBloc extends Bloc<CryptocurrencyEvent, CryptocurrencyState> {
  final CryptocurrencyRepository repository;

  CryptocurrencyBloc({required this.repository}) : super(CryptocurrencyInitial()) {
    on<LoadTopCoins>(_onLoadTopCoins);
    on<LoadCoinDetails>(_onLoadCoinDetails);
  }

  Future<void> _onLoadTopCoins(
    LoadTopCoins event,
    Emitter<CryptocurrencyState> emit,
  ) async {
    emit(CryptocurrencyLoading());

    final result = await repository.getTopCoins(
      currency: ApiConstants.defaultCurrency,
      perPage: ApiConstants.defaultPerPage,
      order: ApiConstants.defaultOrder,
      sparkline: ApiConstants.defaultSparkline,
    );

    result.fold(
      (failure) => emit(CryptocurrencyError(failure.message)),
      (coins) => emit(TopCoinsLoaded(coins)),
    );
  }

  Future<void> _onLoadCoinDetails(
    LoadCoinDetails event,
    Emitter<CryptocurrencyState> emit,
  ) async {
    emit(CryptocurrencyLoading());

    final result = await repository.getCoinDetails(event.coinId);

    result.fold(
      (failure) => emit(CryptocurrencyError(failure.message)),
      (coin) => emit(CoinDetailsLoaded(coin)),
    );
  }
} 