import 'package:flutter/material.dart';

import '../../core/constants/AppColors.dart';
import 'CircularCloseButton.dart';
import 'CustomButton.dart';
import 'CustomTextField.dart';


class RegisterClientModal extends StatelessWidget {


  const RegisterClientModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
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
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre completo *'),
                    CustomTextField(
                      hintText: 'Juan Pérez',
                      inputType: 'text',
                    ),

                    SizedBox(height: 10),

                    Text('Dirección de entrega *'),
                    CustomTextField(
                      hintText: 'Calle 123 #45-67, Apto 202',
                      inputType: 'text',
                    ),

                    SizedBox(height: 10),

                    Text('Ciudad y departamento *'),
                    CustomTextField(
                      hintText: 'Bogotá, Cundinamarca',
                      inputType: 'text',
                    ),

                    SizedBox(height: 10),

                    Text('Número de celular *'),
                    CustomTextField(
                      hintText: '3001234567',
                      inputType: 'number',
                    ),

                    SizedBox(height: 10),

                    Text('Correo electrónico *'),
                    CustomTextField(
                      hintText: 'correo@dominio.com',
                      inputType: 'email',
                    ),

                  ],
                ),
              ),

              Divider(color: Colors.grey, height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  label: 'Continuar',
                  baseColor: AppColors.redPrimary,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pop();
                  }
                ),
              )






            ],
          ),
        ),
      ),
    );
  }
}
