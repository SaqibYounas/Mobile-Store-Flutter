import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/config/app_routes.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/core/app_toast.dart';
import 'package:e_commerce_flutter/src/core/app_typography.dart';
import 'package:e_commerce_flutter/src/core/services/order_service.dart';
import 'package:e_commerce_flutter/src/core/services/payment_service.dart';
import 'package:e_commerce_flutter/src/core/services/session_service.dart';
import 'package:e_commerce_flutter/src/model/order.dart';
import 'package:e_commerce_flutter/src/model/payment.dart';
import 'package:e_commerce_flutter/src/model/payment_method.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';
import 'package:e_commerce_flutter/src/view/widget/outlined_text_field.dart';
import 'package:e_commerce_flutter/src/view/widget/payment/card_form.dart';
import 'package:e_commerce_flutter/src/view/widget/payment/cod_pane.dart';
import 'package:e_commerce_flutter/src/view/widget/payment/order_summary_card.dart';
import 'package:e_commerce_flutter/src/view/widget/payment/payment_method_selector.dart';

/// Checkout screen — collects delivery info, payment method, card
/// details (if online) and submits the order via [OrderService] +
/// [PaymentService].
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardNoController = TextEditingController();
  final _holderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.online;
  bool _loading = false;

  ProductController get _products => Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    for (final c in [_cardNoController, _holderController, _expiryController]) {
      c.addListener(_onPreviewFieldChanged);
    }
    _nameController.text = SessionService.userName ?? '';
  }

  void _onPreviewFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in [
      _cardNoController,
      _holderController,
      _expiryController,
      _cvvController,
      _nameController,
      _phoneController,
      _addressController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userId = SessionService.userId;
    if (userId == null) {
      AppToast.error('Login required', 'Please log in before placing an order');
      return;
    }
    if (_products.cartProducts.isEmpty) {
      AppToast.error('Empty cart', 'Add products before checking out');
      return;
    }

    setState(() => _loading = true);
    final isOnline = _paymentMethod == PaymentMethod.online;

    try {
      final order = await OrderService.placeOrder(
        userId: userId,
        recipientName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        shippingAddress: _addressController.text.trim(),
        cartProducts: _products.cartProducts.toList(),
        status: isOnline ? OrderStatus.paid : OrderStatus.cod,
      );

      final expiry = _expiryController.text.split('/');
      await PaymentService.savePayment(
        orderId: order.id!,
        amount: order.totalAmount,
        paymentMethod: isOnline ? 'card' : 'cod',
        status: isOnline ? PaymentStatus.paid : PaymentStatus.cod,
        cardholderName: isOnline ? _holderController.text.trim() : null,
        cardNumber:
            isOnline ? _cardNoController.text.replaceAll(' ', '') : null,
        expiryMonth: isOnline && expiry.isNotEmpty ? expiry[0] : null,
        expiryYear: isOnline && expiry.length > 1 ? expiry[1] : null,
      );

      _products.clearCart();
      if (!mounted) return;
      AppToast.success(
        isOnline ? 'Payment successful' : 'Order placed',
        isOnline ? 'Your order is confirmed.' : 'Pay on delivery.',
      );
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (_) => false);
    } catch (e) {
      if (!mounted) return;
      AppToast.error('Checkout failed', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = _paymentMethod == PaymentMethod.online;
    final total = _products.totalPrice.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: AppText.headingLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderSummaryCard(total: total),
              const SizedBox(height: 20),
              const Text('Delivery Details', style: AppText.sectionTitle),
              const SizedBox(height: 12),
              OutlinedTextField(
                label: 'Full Name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              OutlinedTextField(
                label: 'Phone Number',
                icon: Icons.phone_android,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              OutlinedTextField(
                label: 'Shipping Address',
                icon: Icons.location_on_outlined,
                controller: _addressController,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              const Text('Payment Method', style: AppText.sectionTitle),
              const SizedBox(height: 12),
              PaymentMethodSelector(
                selected: _paymentMethod,
                onChanged: (m) => setState(() => _paymentMethod = m),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isOnline
                    ? CardForm(
                        key: const ValueKey('card'),
                        cardNoController: _cardNoController,
                        holderController: _holderController,
                        expiryController: _expiryController,
                        cvvController: _cvvController,
                      )
                    : const CodPane(key: ValueKey('cod')),
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: isOnline ? 'Pay Rs.$total' : 'Confirm Order',
                onPressed: _submit,
                isLoading: _loading,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
