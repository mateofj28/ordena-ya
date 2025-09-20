// login_page.dart
import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/validators.dart';
import 'package:ordena_ya/presentation/pages/register_screen.dart';
import 'package:ordena_ya/presentation/widgets/loading_overlay.dart';
import 'package:ordena_ya/presentation/widgets/password_field.dart';
import '../../core/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);

    // Simula petición al backend
    await Future.delayed(const Duration(seconds: 5));

    setState(() => _isLoading = false);

    // Aquí llamas a tu lógica de navegación si fue exitoso
  }

  @override
  void dispose() {
    // ✅ Liberar recursos

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    SizedBox(
                      width: 210,
                      child: const Text(
                        "Bienvenido de nuevo",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Inicia sesión para continuar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecundary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: emailController,
                      hintText: "Correo electronico",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => CustomValidators.email(value),
                    ),

                    const SizedBox(height: 10),

                    PasswordField(controller: passwordController),

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
                          foregroundColor:
                              AppColors.redPrimary, // color del texto
                          side: const BorderSide(
                            color: AppColors.redPrimary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.register,
                          );
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
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: PrimaryButton(
              text: "Entrar al Home",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _login();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

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
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          elevation: 2, // efecto de sombra sutil
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
