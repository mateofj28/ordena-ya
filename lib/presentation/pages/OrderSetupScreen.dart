import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter/services.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';
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
    int step = provider.clienteStep;
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController cedulaController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

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
                    Text('Cliente', style: labelStyle),
                    const SizedBox(height: 8),
                    CustomAutocomplete(
                      options: provider.clients,
                      initialValue: provider.selectedClient,
                      onSelected:
                          (value) => provider.updateSelectedClient(value),
                    ),

                    const SizedBox(height: 12),

                    CustomButton(
                      label: 'Agregar cliente',
                      baseColor: AppColors.primaryButton,
                      onTap: () {
                        provider.clienteStep = 1;
                      },
                    ),

                    // ----
                  ] else if (step == 1) ...[
                    Text('Registrar Cliente', style: labelStyle),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,

                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                      onSaved: (value) => provider.name = value!,
                      textInputAction: TextInputAction.next,
                    ),

                    SizedBox(height: 10),

                    // Campo para la cédula (solo 10 caracteres numéricos)
                    TextFormField(
                      controller: cedulaController,

                      decoration: InputDecoration(
                        labelText: 'Cédula',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La cédula es requerida';
                        } else if (value.length < 8 || value.length > 10) {
                          return 'Debe tener entre 8 a 10 dígitos';
                        }
                        return null;
                      },
                      onSaved: (value) => provider.cedula = value!,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 12),

                    // Campo para el correo
                    TextFormField(
                      controller: emailController,

                      decoration: InputDecoration(
                        labelText: 'Correo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El correo es requerido';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Correo no válido';
                        }
                        return null;
                      },
                      onSaved: (value) => provider.email = value!,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 50,
                          height: 50,

                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              HugeIcons.strokeRoundedUserRemove02,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              provider.clienteStep = 0;
                            },
                          ),
                        ),

                        SizedBox(width: 20),

                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              HugeIcons.strokeRoundedAddMale,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (provider.validateForm()) {
                                try {
                                  provider.saveForm();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Cliente creada exitosamente',
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } catch (e) {
                                  Functions.showErrorSnackBar(
                                    context,
                                    'Error al crear el Cliente: $e',
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

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
      ),
    );
  }
}
