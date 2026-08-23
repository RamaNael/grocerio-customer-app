import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/order_model.dart';
import 'package:snap_ecommerce_app/views/buttonNav/navPages/order/update_order.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  OrderModel? order;
  String? currentStatus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the order only once when this page opens.
    if (order == null) {
      order = ModalRoute.of(context)!.settings.arguments as OrderModel;
      currentStatus = order!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderData = order!;
    final status = currentStatus ?? orderData.status;

    final dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

    Widget sectionCard({
      required IconData icon,
      required Color iconColor,
      required Color iconBackground,
      required String title,
      required Widget child,
    }) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 11),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      );
    }

    Widget detailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 92,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // ORDER HEADER
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.replaceAll('_', ' '),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${orderData.total}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateTimeFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(orderData.created_at),
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // =========================
            // DELIVERY INFORMATION
            // =========================
            sectionCard(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.primaryDark,
              iconBackground: AppColors.primarySoft,
              title: 'Delivery information',
              child: Column(
                children: [
                  detailRow('Order ID', orderData.id_order),
                  detailRow('Customer', orderData.name),
                  detailRow('Phone', orderData.phone),
                  detailRow('Address', orderData.address),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // =========================
            // ORDERED ITEMS
            // =========================
            sectionCard(
              icon: Icons.shopping_bag_outlined,
              iconColor: AppColors.accent,
              iconBackground: AppColors.accentSoft,
              title: 'Ordered items',
              child: Column(
                children: orderData.productsList.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.memory(
                              base64Decode(item.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity} × \$${item.single_price}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.total_price}',
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // =========================
            // PAYMENT OVERVIEW
            // =========================
            sectionCard(
              icon: Icons.payments_outlined,
              iconColor: AppColors.success,
              iconBackground: const Color(0xFFEAF7EC),
              title: 'Payment overview',
              child: Column(
                children: [
                  detailRow('Discount', '\$${orderData.discount}'),
                  detailRow('Total', '\$${orderData.total}'),

                  // IMPORTANT:
                  // Use currentStatus instead of
                  // orderData.status.
                  detailRow('Status', status.replaceAll('_', ' ')),
                ],
              ),
            ),

            // =========================
            // ORDER OPTIONS BUTTON
            // =========================
            if (status == 'PAID' || status == 'ON_THE_WAY') ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Order options'),
                  onPressed: () async {
                    // Wait for UpdateOrder to return
                    // true when cancellation succeeds.
                    final cancelled = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return UpdateOrder(orderData: orderData);
                      },
                    );

                    if (!mounted) return;

                    // Cancellation was successful.
                    if (cancelled == true) {
                      setState(() {
                        currentStatus = 'CANCELLED';

                        // Also update the local OrderModel.
                        orderData.status = 'CANCELLED';
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order cancelled successfully.'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
