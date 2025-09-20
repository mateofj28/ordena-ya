// register_page.dart
import 'package:flutter/material.dart';
import 'package:ordena_ya/core/app_routes.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/pages/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                SizedBox(
                  width: 210,
                  child: const Text(
                    "Bienvenido Usuario",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Crea una cuenta para unirte",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecundary,
                  ),
                ),

                const SizedBox(height: 20),

                CustomTextField(hintText: "Nombre de usuario"),

                const SizedBox(height: 10),

                CustomTextField(hintText: "Correo electronico"),

                const SizedBox(height: 10),

                CustomTextField(hintText: "Contraseña"),

                const SizedBox(height: 10),

                CustomTextField(hintText: "Nombre"),

                const SizedBox(height: 10),

                CustomTextField(hintText: "Apellido"),

                const SizedBox(height: 40),

                Center(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16
                        ),
                        children: [
                          const TextSpan(text: "¿Ya tienes una cuenta? "),
                          TextSpan(
                            text: "Inicia sesión",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.redPrimary, // para que parezca clickeable
                            ),
                            // on enteras se puede agregar un recognizer para navegación
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: "Registrarse", 
            onPressed: (){

            }
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF5F5F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}
