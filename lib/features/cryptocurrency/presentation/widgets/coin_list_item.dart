import 'package:flutter/material.dart';
import '../../domain/entities/coin.dart';
import '../pages/coin_detail_page.dart';
import 'dart:developer' as dev;
import 'package:intl/intl.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  const CoinListItem({
    Key? key,
    required this.coin,
    required this.onTap,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log('Building CoinListItem for ${coin.name}:');
    dev.log('Current Price: ${coin.currentPrice}');
    dev.log('Price Change 24h: ${coin.priceChange24h}');
    dev.log('Price Change Percentage 24h: ${coin.priceChangePercentage24h}');

    final priceChangeColor = (coin.priceChange24h ?? 0) >= 0 ? Colors.green : Colors.red;
    final priceChangeIcon = (coin.priceChange24h ?? 0) >= 0 
        ? Icons.arrow_upward 
        : Icons.arrow_downward;

    final formattedPrice = coin.currentPrice != null 
        ? '\$${coin.currentPrice!.toStringAsFixed(2)}'
        : '\$null';
    
    final formattedPercentage = coin.priceChangePercentage24h != null
        ? '${coin.priceChangePercentage24h!.toStringAsFixed(2)}%'
        : 'null%';

    dev.log('Formatted values:');
    dev.log('Price: $formattedPrice');
    dev.log('Percentage: $formattedPercentage');

    final numberFormat = NumberFormat.currency(symbol: '\$');
    final percentageFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Image.network(
                      coin.image,
                      width: 40,
                      height: 40,
                    ),
                    if (coin.isFavorite)
                      const Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                  ],
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
                    formattedPrice,
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
                        formattedPercentage,
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
              IconButton(
                icon: Icon(
                  coin.isFavorite ? Icons.star : Icons.star_border,
                  color: coin.isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: onFavoritePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 