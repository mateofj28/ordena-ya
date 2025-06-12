import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/widgets/IconActionButton.dart';
import 'package:flutter/services.dart';

class BuildClientRegistration extends StatelessWidget {
  final OrderSetupProvider provider;
  final TextStyle labelStyle;

  const BuildClientRegistration({
    super.key,
    required this.provider,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {

    final TextEditingController nameController = TextEditingController();
    final TextEditingController cedulaController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Column(
      children: [
        Text('Registrar Cliente', style: labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: nameController,

          decoration: InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),

          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La cédula es requerida';
            } else if (value.length != 7 && value.length != 10) {
              return 'Debe tener exactamente 7 o 10 dígitos';
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El correo es requerido';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
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
            IconActionButton(
              icon: HugeIcons.strokeRoundedUserRemove02,
              color: Colors.red,
              onPressed: () {
                provider.clienteStep = 0;
              },
            ),

            SizedBox(width: 20),

            IconActionButton(
              icon: HugeIcons.strokeRoundedAddMale,
              color: Colors.blue,
              onPressed: () {
                if (provider.validateForm()) {
                  provider.saveForm(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
