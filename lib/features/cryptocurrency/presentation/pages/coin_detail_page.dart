import 'package:flutter/material.dart';
import '../../domain/entities/coin.dart';
import '../widgets/price_chart.dart';

class CoinDetailPage extends StatelessWidget {
  final Coin coin;

  const CoinDetailPage({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final priceChangeColor = (coin.priceChange24h ?? 0) >= 0 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      coin.image,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${coin.currentPrice?.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: priceChangeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(coin.priceChangePercentage24h ?? 0) >= 0 ? '+' : ''}${coin.priceChangePercentage24h?.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: priceChangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (coin.sparklineData != null && coin.sparklineData!.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Chart (7d)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PriceChart(
                        prices: coin.sparklineData!,
                        lineColor: priceChangeColor,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildInfoCard(
              context: context,
              title: 'Market Cap Rank',
              value: '#${coin.marketCapRank}',
            ),
            _buildInfoCard(
              context: context,
              title: 'Market Cap',
              value: '\$${_formatNumber(coin.marketCap ?? 0)}',
            ),
            _buildInfoCard(
              context: context,
              title: '24h High',
              value: '\$${coin.high24h?.toStringAsFixed(2)}',
            ),
            _buildInfoCard(
              context: context,
              title: '24h Low',
              value: '\$${coin.low24h?.toStringAsFixed(2)}',
            ),
            _buildInfoCard(
              context: context,
              title: '24h Price Change',
              value: '\$${coin.priceChange24h?.toStringAsFixed(2)}',
              valueColor: priceChangeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }
} 