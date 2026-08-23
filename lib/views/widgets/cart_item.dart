import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_ecommerce_app/Providers/cart_provider.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/cart_model.dart';
import 'package:snap_ecommerce_app/viewModel/common_veiw_model.dart';

class CartItem extends StatefulWidget {
  final Uint8List imageBytes;
  final String nameProduct;
  final String productID;
  final int new_price_Product;
  final int old_price_Product;
  final int maxQuantity;
  final int chosenQuantity;

  const CartItem({
    super.key,
    required this.imageBytes,
    required this.nameProduct,
    required this.productID,
    required this.new_price_Product,
    required this.old_price_Product,
    required this.maxQuantity,
    required this.chosenQuantity,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantityCount = 1;
  final CommonViewModel commonViewModel = CommonViewModel();

  @override
  void initState() {
    super.initState();
    quantityCount = widget.chosenQuantity;
  }

  void incrementQuantity(int maxQuantity) {
    if (quantityCount >= maxQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum quantity reached.')),
      );
      return;
    }

    Provider.of<CartProvider>(context, listen: false).addItemDataToCart(
      CartModel(productID: widget.productID, quantity: quantityCount),
    );
    setState(() => quantityCount++);
  }

  void decrementQuantity() {
    if (quantityCount <= 1) return;
    Provider.of<CartProvider>(context, listen: false)
        .decreaseQuantityCount(widget.productID);
    setState(() => quantityCount--);
  }

  @override
  Widget build(BuildContext context) {
    final discount = commonViewModel.getDiscountPercentage(
      widget.old_price_Product,
      widget.new_price_Product,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 86,
                width: 86,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.memory(widget.imageBytes, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nameProduct,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${widget.new_price_Product}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${widget.old_price_Product}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$discount% off',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove item',
                onPressed: () => Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).deleteItemFromCart(widget.productID),
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _QuantityButton(
                icon: Icons.remove_rounded,
                onTap: decrementQuantity,
              ),
              SizedBox(
                width: 42,
                child: Text(
                  '$quantityCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
              _QuantityButton(
                icon: Icons.add_rounded,
                onTap: () => incrementQuantity(widget.maxQuantity),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  Text(
                    '\$${widget.new_price_Product * quantityCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryDark),
      ),
    );
  }
}
