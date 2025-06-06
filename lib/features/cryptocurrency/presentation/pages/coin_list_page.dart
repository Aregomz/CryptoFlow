import 'package:flutter/material.dart';
import '../../domain/entities/coin.dart';
import '../widgets/coin_list_item.dart';
import '../../data/datasources/cryptocurrency_remote_data_source.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../pages/coin_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinListPage extends StatefulWidget {
  const CoinListPage({Key? key}) : super(key: key);

  @override
  State<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends State<CoinListPage> {
  final CryptocurrencyRemoteDataSource _dataSource = CryptocurrencyRemoteDataSourceImpl();
  late final FavoritesLocalDataSource _favoritesDataSource;
  List<Coin> _coins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
    _loadCoins();
  }

  Future<void> _initializeFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoritesDataSource = FavoritesLocalDataSource(sharedPreferences: prefs);
    await _loadCoins();
  }

  Future<void> _loadCoins() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final coins = await _dataSource.getTopCoins();
      final favorites = await _favoritesDataSource.getFavorites();
      
      final coinsWithFavorites = coins.map((coin) {
        return coin.copyWith(isFavorite: favorites.contains(coin.id));
      }).toList();

      // Sort coins with favorites at the top
      coinsWithFavorites.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return (a.marketCapRank ?? 0).compareTo(b.marketCapRank ?? 0);
      });

      setState(() {
        _coins = coinsWithFavorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading coins: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Coin coin) async {
    await _favoritesDataSource.toggleFavorite(coin.id);
    await _loadCoins(); // Reload to update the order
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cryptocurrency Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCoins,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCoins,
              child: ListView.builder(
                itemCount: _coins.length,
                itemBuilder: (context, index) {
                  final coin = _coins[index];
                  return CoinListItem(
                    coin: coin,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinDetailPage(coin: coin),
                        ),
                      );
                    },
                    onFavoritePressed: () => _toggleFavorite(coin),
                  );
                },
              ),
            ),
    );
  }
} 