import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/utils/error.dart';
import 'package:ordena_ya/core/utils/validators.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/presentation/pages/register_user_screen.dart';
import 'package:ordena_ya/presentation/providers/user_provider.dart';
import 'package:ordena_ya/presentation/widgets/status_display.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import 'CircularCloseButton.dart';
import 'custom_button.dart';

class RegisterClientModal extends StatefulWidget {
  const RegisterClientModal({super.key});

  @override
  State<RegisterClientModal> createState() => _RegisterClientModalState();
}

class _RegisterClientModalState extends State<RegisterClientModal> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody(UserProvider provider, BuildContext context) {
    if (provider.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {      
      return StatusDisplay(
        message: extractErrorMessage(provider.error!),                      
        iconColor: AppColors.redTotal, 
        icon: HugeIcons.strokeRoundedRssError, 
        onAction: () {  
          context.read<UserProvider>().setError(null);          
        }, 
        iconButton: Icons.arrow_back_rounded, 
        labelButton: 'Volver al formulario', 
        backgroundColorButton: AppColors.redTotal,                       
        foregroundColorButton: Colors.white,
      );
    }

    if (provider.currentClient != null) {
      return _buildSuccess(provider.currentClient?.id);
    }
    return _buildClientForm(context: context, formKey: _formKey);
  }

  Widget _buildSuccess(String? id) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40, // tamaño del círculo
            backgroundColor: Colors.green.withValues(
              alpha: 0.1,
            ), // color de fondo suave
            child: HugeIcon(
              color: Colors.green,
              size: 48,
              icon: HugeIcons.strokeRoundedTick03,
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'Cliente registrado con éxito',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'El cliente con ID ${id ?? 'N/A'} ha sido creado para esta orden.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Widget _buildClientForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Datos del cliente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CircularCloseButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 0),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nombre completo *'),
                  CustomTextField(
                    controller: fullNameController,
                    hintText: 'Juan Pérez',
                    validator: (value) => CustomValidators.name(value),
                  ),
                  const SizedBox(height: 10),
                  const Text('Dirección de entrega *'),
                  CustomTextField(
                    controller: addressController,
                    hintText: 'Calle 123 #45-67, Apto 202',
                    validator:
                        (value) => CustomValidators.required(
                          value,
                          fieldName: "Dirección",
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Ciudad y departamento *'),
                  CustomTextField(
                    controller: cityController,
                    hintText: 'Bogotá, Cundinamarca',
                    validator:
                        (value) =>
                            CustomValidators.required(value, fieldName: "Ciudad"),
                  ),
                  const SizedBox(height: 10),
                  const Text('Número de celular *'),
                  CustomTextField(
                    controller: phoneController,
                    hintText: '3001234567',
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) => CustomValidators.phone(value),
                  ),
                  const SizedBox(height: 10),
                  const Text('Correo electrónico *'),
                  CustomTextField(
                    controller: emailController,
                    hintText: 'correo@dominio.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => CustomValidators.email(value),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                label: 'Continuar',
                baseColor: AppColors.redPrimary,
                textColor: Colors.white,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<UserProvider>().registerClient(
                      ClientModel(
                        fullName: fullNameController.text,
                        deliveryAddress: addressController.text,
                        city: cityController.text,
                        phoneNumber: phoneController.text,
                        email: emailController.text,
                      ),
                    );
                    _clearData();
                    Future.delayed(const Duration(seconds: 3));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearData() {
    emailController.clear();
    fullNameController.clear();
    addressController.clear();
    cityController.clear();
    phoneController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: _buildBody(provider, context),
      ),
    );
  }
}
