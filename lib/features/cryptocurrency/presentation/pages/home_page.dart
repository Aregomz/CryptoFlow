import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cryptocurrency_bloc.dart';
import '../widgets/coin_list_item.dart';
import '../widgets/error_message.dart';
import '../widgets/loading_indicator.dart';
import '../pages/coin_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CryptoFlow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<CryptocurrencyBloc, CryptocurrencyState>(
        builder: (context, state) {
          if (state is CryptocurrencyInitial) {
            context.read<CryptocurrencyBloc>().add(const LoadTopCoins());
            return const LoadingIndicator();
          } else if (state is CryptocurrencyLoading) {
            return const LoadingIndicator();
          } else if (state is CryptocurrencyError) {
            return ErrorMessage(message: state.message);
          } else if (state is TopCoinsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CryptocurrencyBloc>().add(const LoadTopCoins());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.coins.length,
                itemBuilder: (context, index) {
                  final coin = state.coins[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CoinListItem(
                      coin: coin,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinDetailPage(coin: coin),
                        ),
                      ),
                      onFavoritePressed: () {
                        context.read<CryptocurrencyBloc>().add(ToggleFavorite(coin));
                      },
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 