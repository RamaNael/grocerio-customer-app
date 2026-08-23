import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/order_model.dart';
import 'package:snap_ecommerce_app/models/order_product_model.dart.dart';
import 'package:snap_ecommerce_app/viewModel/order_veiw_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderViewModel orderViewModel = OrderViewModel();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  int totalQuantityCalculator(List<OrderProductModel> productList) {
    return productList.fold(0, (sum, product) => sum + product.quantity);
  }

  Widget _orderStatusBadge(String orderStatus) {
    late Color color;
    late Color background;

    switch (orderStatus) {
      case 'PAID':
        color = AppColors.primaryDark;
        background = AppColors.primarySoft;
        break;
      case 'ON_THE_WAY':
        color = AppColors.accent;
        background = AppColors.accentSoft;
        break;
      case 'DELIVERED':
        color = AppColors.success;
        background = const Color(0xFFEAF7EC);
        break;
      default:
        color = AppColors.danger;
        background = const Color(0xFFFFECEE);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        orderStatus.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: StreamBuilder(
        stream: orderViewModel.fetchOrders(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = OrderModel.fromJsonList(dataSnapshot.data!.docs);
          if (orders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 62,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your completed purchases will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              final quantity = totalQuantityCalculator(order.productsList);

              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/order_details',
                    arguments: order,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id_order.length > 8 ? order.id_order.substring(0, 8) : order.id_order}',
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateFormat.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        order.created_at,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _orderStatusBadge(order.status),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Text(
                              '$quantity ${quantity == 1 ? 'item' : 'items'}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${order.total}',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
