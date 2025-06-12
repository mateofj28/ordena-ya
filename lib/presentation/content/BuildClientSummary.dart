import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/widgets/IconActionButton.dart';

class BuildClientSummary extends StatelessWidget {
  final OrderSetupProvider provider;
  final TextStyle labelStyle;
  
  const BuildClientSummary({
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
        Text(
          provider.selectedClient,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconActionButton(
              icon: HugeIcons.strokeRoundedUserSearch01,
              color: Colors.blue,
              onPressed: () {
                provider.clienteStep = 0;
              },
            ),

            SizedBox(width: 10),

            IconActionButton(
              icon: HugeIcons.strokeRoundedAddMale,
              color: Colors.green,
              onPressed: () {
                provider.clienteStep = 1;
              },
            ),

            SizedBox(width: 10),

            IconActionButton(
              icon: HugeIcons.strokeRoundedDelete02,
              color: Colors.red,
              onPressed: () {
                provider.clienteStep = 0;
                provider.updateSelectedClient('');
              },
            ),
          ],
        ),
      ],
    );
  }
}
