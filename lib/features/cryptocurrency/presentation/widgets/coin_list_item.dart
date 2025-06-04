import 'package:flutter/material.dart';
import '../../domain/entities/coin.dart';
import '../pages/coin_detail_page.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;

  const CoinListItem({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final priceChangeColor = coin.priceChange24h >= 0 ? Colors.green : Colors.red;
    final priceChangeIcon = coin.priceChange24h >= 0 
        ? Icons.arrow_upward 
        : Icons.arrow_downward;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinDetailPage(coin: coin),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  coin.image,
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${coin.currentPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        priceChangeIcon,
                        color: priceChangeColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: priceChangeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 