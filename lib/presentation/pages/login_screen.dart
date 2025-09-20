// login_page.dart
import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/widgets/password_field.dart';
import '../../core/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                SizedBox(
                  width: 210,
                  child: const Text(
                    "Bienvenido de nuevo",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Inicia sesión para continuar",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecundary),
                ),

                const SizedBox(height: 20),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'Username@gmail.com',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7), // gris claro
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // bordes redondeados
                      borderSide: BorderSide.none, // sin borde visible
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 10),

                PasswordField(),

                const SizedBox(height: 30),

                Center(
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.redPrimary, // color del texto
                      side: const BorderSide(color: AppColors.redPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                    ),
                    onPressed: () {                  
                      Navigator.pushReplacementNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      "Ir a Registrar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 200),

                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: "Entrar al Home", 
            onPressed: (){

            }
          ),
        ),
      ),
    );
  }
}




class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.redPrimary,
          foregroundColor: Colors.white, // color del texto
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          elevation: 2, // efecto de sombra sutil
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
