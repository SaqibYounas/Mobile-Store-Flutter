import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';

/// Animated credit-card preview that mirrors the user's input as they
/// type the card details on the checkout form.
class CardPreview extends StatelessWidget {
  const CardPreview({
    super.key,
    required this.number,
    required this.holder,
    required this.expiry,
  });

  final String number;
  final String holder;
  final String expiry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.paymentBlue, Color(0xFF211F5E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.credit_card, color: Colors.white70, size: 30),
          Text(
            number.isEmpty ? '•••• •••• •••• ••••' : number,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                holder.isEmpty ? 'CARD HOLDER' : holder.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                expiry.isEmpty ? 'MM/YY' : expiry,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
