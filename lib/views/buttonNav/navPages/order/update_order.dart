import 'package:flutter/material.dart';
import 'package:snap_ecommerce_app/core/theme/app_theme.dart';
import 'package:snap_ecommerce_app/models/order_model.dart';
import 'package:snap_ecommerce_app/viewModel/order_veiw_model.dart';
import 'package:snap_ecommerce_app/views/widgets/confirm_action_dialog.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModel orderData;

  const UpdateOrder({super.key, required this.orderData});

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  final OrderViewModel orderViewModel = OrderViewModel();

  bool isCancelling = false;

  // ============================
  // CANCEL ORDER
  // ============================
  Future<void> cancelOrder() async {
    if (isCancelling) return;

    setState(() {
      isCancelling = true;
    });

    try {
      // Update Firestore.
      await orderViewModel.updateOrderStatus(
        docId: widget.orderData.id_order,
        orderData: {'status': 'CANCELLED'},
      );

      if (!mounted) return;

      // IMPORTANT:
      // Close UpdateOrder and return true
      // to OrderDetailsPage.
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isCancelling = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to cancel order: $error')));
    }
  }

  // ============================
  // CONFIRM CANCELLATION
  // ============================
  Future<void> showCancelConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (confirmContext) {
        return ConfirmActionDialog(
          dialogBodyText:
              'Once canceled, this order cannot be changed. '
              'To receive these items, you’ll need to place a new order.',

          onYesCallBack: () {
            // Close confirmation dialog
            // and return true.
            Navigator.pop(confirmContext, true);
          },

          onNoCallBack: () {
            // Close confirmation dialog
            // and return false.
            Navigator.pop(confirmContext, false);
          },
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      await cancelOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isCancelling,
      child: AlertDialog(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primarySoft,
              child: Icon(
                Icons.tune_rounded,
                color: AppColors.primaryDark,
                size: 19,
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Text('Order options')),
          ],
        ),

        content: const Text(
          'You can cancel this order while it is still being processed.',
          style: TextStyle(color: AppColors.textSecondary),
        ),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        actions: [
          // ============================
          // KEEP ORDER
          // ============================
          TextButton(
            onPressed: isCancelling
                ? null
                : () {
                    Navigator.pop(context, false);
                  },
            child: const Text('Keep order'),
          ),

          // ============================
          // CANCEL ORDER BUTTON
          // ============================
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),

            onPressed: isCancelling ? null : showCancelConfirmation,

            icon: isCancelling
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.cancel_outlined),

            label: Text(isCancelling ? 'Cancelling...' : 'Cancel order'),
          ),
        ],
      ),
    );
  }
}
