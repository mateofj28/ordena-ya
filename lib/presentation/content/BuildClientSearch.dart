import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/widgets/CustomAutoComplete.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';

class BuildClientSearch extends StatelessWidget {
  final OrderSetupProvider provider;
  final TextStyle labelStyle;

  const BuildClientSearch({
    super.key,
    required this.provider,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Cliente', style: labelStyle),
        const SizedBox(height: 8),
        CustomAutocomplete(
          options: provider.clients,
          initialValue: provider.selectedClient,
          onSelected: (value) => provider.updateSelectedClient(value),
        ),

        const SizedBox(height: 12),

        CustomButton(
          label: 'Agregar cliente',
          baseColor: AppColors.redPrimary,
          textColor: Colors.white,
          onTap: () {
            provider.clienteStep = 1;
          },
        ),
      ],
    );
  }
}
