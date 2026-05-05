import 'package:flutter/material.dart';

/// Informational notice shown when the user picks Cash on Delivery.
class CodPane extends StatelessWidget {
  const CodPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'You will pay in cash when the order is delivered.',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
