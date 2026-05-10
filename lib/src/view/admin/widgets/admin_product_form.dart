import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_flutter/src/controller/admin_controller.dart';
import 'package:e_commerce_flutter/src/core/app_color.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:e_commerce_flutter/src/view/admin/widgets/discount_type_selector.dart';
import 'package:e_commerce_flutter/src/view/widget/form_section.dart';
import 'package:e_commerce_flutter/src/view/widget/form_text_field.dart';
import 'package:e_commerce_flutter/src/view/widget/gradient_button.dart';

/// Bottom-sheet form used for both creating and editing a product.
/// Composes reusable form widgets ([FormSection], [FormTextField],
/// [DiscountTypeSelector]) — keeps the form file focused on field
/// declarations and submit logic only.
class AdminProductForm extends StatefulWidget {
  const AdminProductForm({super.key, this.product});

  final Product? product;

  static Future<void> show(BuildContext context, [Product? product]) {
    return Get.bottomSheet(
      AdminProductForm(product: product),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
  }

  @override
  State<AdminProductForm> createState() => _AdminProductFormState();
}

class _AdminProductFormState extends State<AdminProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _about;
  late final TextEditingController _category;
  late final TextEditingController _imageUrl;
  late final TextEditingController _price;
  late final TextEditingController _discountValue;
  late final TextEditingController _stock;

  late DiscountType _discountType;
  late bool _isActive;
  late bool _isFeatured;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p?.name ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _about = TextEditingController(text: p?.about ?? '');
    _category = TextEditingController(text: p?.category ?? '');
    _imageUrl = TextEditingController(text: p?.imageUrl ?? '');
    _price =
        TextEditingController(text: p == null ? '' : p.price.toString());
    _discountValue =
        TextEditingController(text: p?.discountValue.toString() ?? '0');
    _stock = TextEditingController(text: p?.stockQuantity.toString() ?? '0');
    _discountType = p?.discountType ?? DiscountType.none;
    _isActive = p?.isActive ?? true;
    _isFeatured = p?.isFeatured ?? false;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _description,
      _about,
      _category,
      _imageUrl,
      _price,
      _discountValue,
      _stock,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final p = Product(
      id: widget.product?.id ?? '',
      name: _name.text.trim(),
      description:
          _description.text.trim().isEmpty ? null : _description.text.trim(),
      about: _about.text.trim().isEmpty ? '' : _about.text.trim(),
      category: _category.text.trim().isEmpty ? null : _category.text.trim(),
      imageUrl: _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
      price: double.tryParse(_price.text) ?? 0,
      discountType: _discountType,
      discountValue: double.tryParse(_discountValue.text) ?? 0,
      stockQuantity: int.tryParse(_stock.text) ?? 0,
      isActive: _isActive,
      isFeatured: _isFeatured,
    );
    Get.find<AdminController>().saveProduct(p);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboard = mq.viewInsets.bottom;
    // Subtract the keyboard height from the sheet's max height so the
    // sheet shrinks to fit instead of being pushed off-screen, and let
    // the inner scroll view bring the focused field into view as the
    // user types.
    final maxHeight = (mq.size.height * 0.92 - keyboard).clamp(
      280.0,
      mq.size.height * 0.92,
    );
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DragHandle(),
                  const SizedBox(height: 18),
                  _FormHeader(isEdit: _isEdit),
                  const SizedBox(height: 18),
                  FormSection(
                    title: 'Basics',
                    children: [
                      FormTextField(
                        controller: _name,
                        label: 'Product Name',
                        icon: Icons.shopping_bag_outlined,
                        validator: _required,
                      ),
                      FormTextField(
                        controller: _category,
                        label: 'Category',
                        icon: Icons.category_outlined,
                        hint: 'e.g. Mobile, Tablet, Headphone',
                      ),
                      FormTextField(
                        controller: _imageUrl,
                        label: 'Image File',
                        icon: Icons.image_outlined,
                        hint: 'products/your_image.jpg',
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Description',
                    children: [
                      FormTextField(
                        controller: _description,
                        label: 'Short Description',
                        icon: Icons.short_text,
                      ),
                      FormTextField(
                        controller: _about,
                        label: 'Full Details',
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Pricing & Stock',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FormTextField(
                              controller: _price,
                              label: 'Price (Rs)',
                              icon: Icons.currency_rupee,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              validator: _requiredNumber,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormTextField(
                              controller: _stock,
                              label: 'Stock',
                              icon: Icons.inventory_2_outlined,
                              keyboardType: TextInputType.number,
                              validator: _requiredNonNegativeInt,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Discount',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColor.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DiscountTypeSelector(
                        type: _discountType,
                        onChanged: (t) => setState(() => _discountType = t),
                      ),
                      if (_discountType != DiscountType.none) ...[
                        const SizedBox(height: 10),
                        FormTextField(
                          controller: _discountValue,
                          label: _discountType == DiscountType.percentage
                              ? 'Discount %'
                              : 'Discount Rs',
                          icon: Icons.percent,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: _requiredNumber,
                        ),
                      ],
                    ],
                  ),
                  FormSection(
                    title: 'Visibility',
                    children: [
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active Product'),
                        subtitle: const Text(
                          'Visible to customers when active',
                          style: TextStyle(
                            color: AppColor.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: AppColor.brandIndigo,
                      ),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Featured Product'),
                        subtitle: const Text(
                          'Show on the home featured row',
                          style: TextStyle(
                            color: AppColor.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        value: _isFeatured,
                        onChanged: (v) => setState(() => _isFeatured = v),
                        activeColor: AppColor.brandIndigo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final loading = Get.find<AdminController>().isLoading.value;
                    return GradientButton(
                      text: _isEdit ? 'UPDATE PRODUCT' : 'CREATE PRODUCT',
                      onPressed: loading ? null : _submit,
                      isLoading: loading,
                    );
                  }),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _requiredNumber(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = double.tryParse(v);
    if (n == null) return 'Must be a number';
    if (n < 0) return 'Cannot be negative';
    return null;
  }

  String? _requiredNonNegativeInt(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null) return 'Whole number';
    if (n < 0) return 'Cannot be negative';
    return null;
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
          color: AppColor.brandIndigo.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.brandIndigo.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isEdit ? Icons.edit_note_rounded : Icons.add_box_rounded,
            color: AppColor.brandIndigo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Product' : 'Add New Product',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isEdit
                    ? 'Update the details below'
                    : 'Fill in the details to publish',
                style: const TextStyle(
                  color: AppColor.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
