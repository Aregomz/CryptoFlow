import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/coin.dart';
import '../../data/datasources/cryptocurrency_remote_data_source.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/models/coin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cryptocurrency_event.dart';
part 'cryptocurrency_state.dart';

class CryptocurrencyBloc extends Bloc<CryptocurrencyEvent, CryptocurrencyState> {
  final CryptocurrencyRemoteDataSource _dataSource = CryptocurrencyRemoteDataSourceImpl();
  late final FavoritesLocalDataSource _favoritesDataSource;

  CryptocurrencyBloc() : super(CryptocurrencyInitial()) {
    _initializeFavorites();

    on<LoadTopCoins>((event, emit) async {
      try {
        emit(CryptocurrencyLoading());
        final coins = await _dataSource.getTopCoins();
        final favorites = await _favoritesDataSource.getFavorites();
        
        final coinsWithFavorites = coins.map((coin) {
          return coin.copyWith(isFavorite: favorites.contains(coin.id));
        }).toList();

        coinsWithFavorites.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return (a.marketCapRank ?? 0).compareTo(b.marketCapRank ?? 0);
        });

        emit(TopCoinsLoaded(coinsWithFavorites));
      } catch (e) {
        emit(CryptocurrencyError(e.toString()));
      }
    });

    on<ToggleFavorite>((event, emit) async {
      if (state is TopCoinsLoaded) {
        final currentState = state as TopCoinsLoaded;
        await _favoritesDataSource.toggleFavorite(event.coin.id);
        add(const LoadTopCoins()); // Reload to update the order
      }
    });
  }

  Future<void> _initializeFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoritesDataSource = FavoritesLocalDataSource(sharedPreferences: prefs);
  }
} 