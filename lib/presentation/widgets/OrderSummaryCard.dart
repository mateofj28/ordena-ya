import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/presentation/widgets/IconTextRow.dart';

class OrderSummaryCard extends StatelessWidget {
  final String orderId;
  final String table;
  final String consumptionType;
  final String paymentMethod;
  final String date;
  final String status;
  final double total;
  final Color headerColor;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? totalStyle;

  const OrderSummaryCard({
    super.key,
    required this.orderId,
    required this.table,
    required this.consumptionType,
    required this.paymentMethod,
    required this.date,
    required this.status,
    required this.total,
    this.headerColor = const Color(0xFFBBDEFB), // Azul claro por defecto
    this.backgroundColor = AppColors.yellowStatus,
    this.titleStyle,
    this.totalStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: headerColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconTextRow(
                        icon: Icon(
                          HugeIcons.strokeRoundedInvoice03,
                          color: Colors.black,
                        ),
                        title: orderId,
                      ),
                      IconTextRow(
                        icon: Icon(
                          HugeIcons.strokeRoundedTableRound,
                          color: Colors.black,
                        ),
                        title: table,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text(consumptionType, style: titleStyle)],
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Functions.formatCurrency(total),
                      style:
                          totalStyle ??
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                IconTextRow(
                  icon: Icon(
                    HugeIcons.strokeRoundedPayment01,
                    color: Colors.black,
                  ),
                  title: paymentMethod,
                ),
                const SizedBox(height: 5),
                IconTextRow(
                  icon: Icon(
                    HugeIcons.strokeRoundedStatus,
                    color: Colors.black,
                  ),
                  title: status,
                ),
                const SizedBox(height: 5),

                IconTextRow(
                  icon: Icon(
                    HugeIcons.strokeRoundedDateTime,
                    color: Colors.black,
                  ),
                  title: date,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
