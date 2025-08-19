import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/content/BuildClientRegistration.dart';
import 'package:ordena_ya/presentation/content/BuildClientSearch.dart';
import 'package:ordena_ya/presentation/content/BuildClientSummary.dart';

import 'package:ordena_ya/presentation/providers/order_provider.dart';

import 'package:ordena_ya/presentation/widgets/IconSubtitle.dart';
import 'package:ordena_ya/presentation/widgets/LabeledRadioOption.dart';
import 'package:provider/provider.dart';

class OrderSetupScreen extends StatelessWidget {
  const OrderSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    int step = provider.clienteStep;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  IconSubtitle(
                    icon: HugeIcons.strokeRoundedDeliveryBox01,
                    text: 'Tipo de pedido',
                    color: Colors.grey[800],
                  ),

                  const SizedBox(height: 12),

                  LabeledRadioOption(
                    label: 'Consumir en el local',
                    value: 0,
                    groupValue: provider.deliveryType,
                    onChanged: (val) => provider.updateDeliveryType(val!),
                  ),
                  LabeledRadioOption(
                    label: 'Entregar a domicilio',
                    value: 1,
                    groupValue: provider.deliveryType,
                    onChanged: (val) => provider.updateDeliveryType(val!),
                  ),
                  LabeledRadioOption(
                    label: 'Recoger personalmente',
                    value: 2,
                    groupValue: provider.deliveryType,
                    onChanged: (val) => provider.updateDeliveryType(val!),
                  ),

                  const SizedBox(height: 24),

                  IconSubtitle(
                    icon: HugeIcons.strokeRoundedInvoice01,
                    text: 'Información del pedido',
                    color: Colors.grey[800],
                  ),

                  const SizedBox(height: 12),

                  if (step == 0) ...[
                    BuildClientSearch(
                      provider: provider,
                      labelStyle: labelStyle!,
                    ),
                  ] else if (step == 1) ...[
                    BuildClientRegistration(
                      provider: provider,
                      labelStyle: labelStyle!,
                    ),
                  ] else if (step == 2) ...[
                    BuildClientSummary(
                      provider: provider,
                      labelStyle: labelStyle!,
                    ),
                  ],

                  const SizedBox(height: 24),

                  Text('Mesa', style: labelStyle),
                  const SizedBox(height: 8),


                  const SizedBox(height: 20),

                  Text('Cantidad de personas', style: labelStyle),
                  const SizedBox(height: 8),


                  const SizedBox(height: 24),
                  // Aquí iría la tabla o detalle del pedido
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
