part of 'cryptocurrency_bloc.dart';

abstract class CryptocurrencyEvent extends Equatable {
  const CryptocurrencyEvent();

  @override
  List<Object> get props => [];
}

class LoadTopCoins extends CryptocurrencyEvent {
  const LoadTopCoins();
}

class LoadCoinDetails extends CryptocurrencyEvent {
  final String coinId;

  const LoadCoinDetails(this.coinId);

  @override
  List<Object> get props => [coinId];
} 