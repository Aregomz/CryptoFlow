part of 'cryptocurrency_bloc.dart';

abstract class CryptocurrencyState extends Equatable {
  const CryptocurrencyState();
  
  @override
  List<Object> get props => [];
}

class CryptocurrencyInitial extends CryptocurrencyState {}

class CryptocurrencyLoading extends CryptocurrencyState {}

class CryptocurrencyError extends CryptocurrencyState {
  final String message;

  const CryptocurrencyError(this.message);

  @override
  List<Object> get props => [message];
}

class TopCoinsLoaded extends CryptocurrencyState {
  final List<Coin> coins;

  const TopCoinsLoaded(this.coins);

  @override
  List<Object> get props => [coins];
}

class CoinDetailsLoaded extends CryptocurrencyState {
  final Coin coin;

  const CoinDetailsLoaded(this.coin);

  @override
  List<Object> get props => [coin];
} 