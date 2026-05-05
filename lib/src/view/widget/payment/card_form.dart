import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_commerce_flutter/src/view/widget/outlined_text_field.dart';
import 'package:e_commerce_flutter/src/view/widget/payment/card_preview.dart';

/// Card details form: animated [CardPreview] + holder / number /
/// expiry / CVV inputs. Used when the customer picks Online payment.
class CardForm extends StatelessWidget {
  const CardForm({
    super.key,
    required this.cardNoController,
    required this.holderController,
    required this.expiryController,
    required this.cvvController,
  });

  final TextEditingController cardNoController;
  final TextEditingController holderController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardPreview(
          number: cardNoController.text,
          holder: holderController.text,
          expiry: expiryController.text,
        ),
        const SizedBox(height: 20),
        OutlinedTextField(
          label: 'Card Holder',
          icon: Icons.face,
          controller: holderController,
        ),
        OutlinedTextField(
          label: 'Card Number',
          icon: Icons.credit_card,
          controller: cardNoController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedTextField(
                label: 'Expiry (MM/YY)',
                icon: Icons.calendar_today,
                controller: expiryController,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: OutlinedTextField(
                label: 'CVV',
                icon: Icons.lock_outline,
                controller: cvvController,
                isPassword: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
