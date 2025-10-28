import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/utils/error.dart';
import 'package:ordena_ya/core/utils/validators.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/presentation/pages/register_user_screen.dart';
import 'package:ordena_ya/presentation/providers/user_provider.dart';

import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import 'CircularCloseButton.dart';


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
      return _buildLoadingState();
    }

    if (provider.error != null) {      
      return _buildErrorState(provider, context);
    }

    if (provider.currentClient != null) {
      return _buildSuccess(provider.currentClient?.id);
    }
    return _buildClientForm(context: context, formKey: _formKey);
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            'Registrando cliente...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por favor espera un momento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(UserProvider provider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con botón de cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularCloseButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Icono de error
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.redTotal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              color: AppColors.redTotal,
              size: 48,
              icon: HugeIcons.strokeRoundedRssError,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mensaje de error
          Text(
            extractErrorMessage(provider.error!),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<UserProvider>().setError(null);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redTotal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(String? id) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      constraints: const BoxConstraints(
        maxWidth: 380,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con botón de cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Éxito',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularCloseButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Icono de éxito
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El cliente con ID ${id ?? 'N/A'} ha sido creado para esta orden.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continuar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header fijo
          Container(
            padding: const EdgeInsets.all(16.0),
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
          
          const Divider(height: 1),
          
          // Área de scroll solo para los campos del formulario
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    label: 'Nombre completo *',
                    child: CustomTextField(
                      controller: fullNameController,
                      hintText: 'Juan Pérez',
                      validator: (value) => CustomValidators.name(value),
                    ),
                  ),
                  
                  _buildFormField(
                    label: 'Dirección de entrega *',
                    child: CustomTextField(
                      controller: addressController,
                      hintText: 'Calle 123 #45-67, Apto 202',
                      validator: (value) => CustomValidators.required(
                        value,
                        fieldName: "Dirección",
                      ),
                    ),
                  ),
                  
                  _buildFormField(
                    label: 'Ciudad y departamento *',
                    child: CustomTextField(
                      controller: cityController,
                      hintText: 'Bogotá, Cundinamarca',
                      validator: (value) => CustomValidators.required(
                        value, 
                        fieldName: "Ciudad"
                      ),
                    ),
                  ),
                  
                  _buildFormField(
                    label: 'Número de celular *',
                    child: CustomTextField(
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
                  ),
                  
                  _buildFormField(
                    label: 'Correo electrónico *',
                    child: CustomTextField(
                      controller: emailController,
                      hintText: 'correo@dominio.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => CustomValidators.email(value),
                    ),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Botón fijo en la parte inferior
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
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
                }
              },
              child: const Text(
                'Registrar Cliente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        child,
        if (!isLast) const SizedBox(height: 16),
      ],
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
    final screenSize = MediaQuery.of(context).size;
    
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.85,
          maxWidth: _getMaxWidth(provider, screenSize),
          minWidth: 300,
        ),
        child: _buildBody(provider, context),
      ),
    );
  }

  double _getMaxWidth(UserProvider provider, Size screenSize) {
    // Ajustar ancho según el estado
    if (provider.loading) {
      return 320; // Más pequeño para loading
    } else if (provider.error != null) {
      return 400; // Mediano para errores
    } else if (provider.currentClient != null) {
      return 380; // Mediano para éxito
    } else {
      // Formulario - responsivo según pantalla
      if (screenSize.width > 600) {
        return 500; // Pantallas grandes
      } else {
        return screenSize.width * 0.9; // Pantallas pequeñas
      }
    }
  }
}
