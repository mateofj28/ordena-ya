import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/widgets/CustomAutoComplete.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:ordena_ya/presentation/widgets/CustomDropDown.dart';
import 'package:ordena_ya/presentation/widgets/IconSubtitle.dart';
import 'package:ordena_ya/presentation/widgets/LabeledRadioOption.dart';
import 'package:provider/provider.dart';

class OrderSetupScreen extends StatelessWidget {
  const OrderSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  baseColor: AppColors.primaryButton,
                  onTap: () {},
                ),
          
                const SizedBox(height: 24),
          
                Text('Mesa', style: labelStyle),
                const SizedBox(height: 8),
                CustomDropdown(
                  options: [
                    'Mesa 1',
                    'Mesa 2',
                    'Mesa 3',
                    'Mesa 4',
                    'Mesa 5',
                    'Mesa 6',
                  ],
                  selectedValue: provider.selectedTable,
                  label: 'Mesa',
                  onChanged: (value) {
                    if (value != null) provider.updateSelectedTable(value);
                  },
                ),
          
                const SizedBox(height: 20),
          
                Text('Cantidad de personas', style: labelStyle),
                const SizedBox(height: 8),
                CustomDropdown(
                  options: ['1', '2', '3', '4', '5', '6'],
                  selectedValue: provider.selectedPeople,
                  label: 'Personas',
                  onChanged: (value) {
                    if (value != null) provider.updateSelectedPeople(value);
                  },
                ),
          
                const SizedBox(height: 24),
                // Aquí iría la tabla o detalle del pedido
              ],
            ),
          ),
        ),
      ),
    );
  }
}
