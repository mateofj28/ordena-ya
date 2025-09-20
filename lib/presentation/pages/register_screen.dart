// register_page.dart
import 'package:flutter/material.dart';
import 'package:ordena_ya/core/app_routes.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/constants/app_styles.dart';
import 'package:ordena_ya/core/utils/validators.dart';
import 'package:ordena_ya/presentation/pages/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // ✅ Liberar recursos
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),

                  SizedBox(
                    width: 210,
                    child: const Text(
                      "Bienvenido Usuario",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
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

                  CustomTextField(
                    controller: usernameController,
                    hintText: "Nombre de usuario",
                    validator: CustomValidators.username,
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: emailController,
                    hintText: "Correo electronico",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => CustomValidators.email(value),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: passwordController,
                    hintText: "Contraseña",
                    validator:
                        (v) => CustomValidators.password(v, minLength: 8),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: firstNameController,
                    hintText: "Nombre",
                    validator:
                        (value) =>
                            CustomValidators.name(value, fieldName: "Nombre"),
                  ),

                  const SizedBox(height: 10),

                  CustomTextField(
                    controller: lastNameController,
                    hintText: "Apellido",
                    validator:
                        (value) => CustomValidators.name(
                          value,
                          fieldName: "Apellidos",
                        ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            const TextSpan(text: "¿Ya tienes una cuenta? "),
                            TextSpan(
                              text: "Inicia sesión",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    AppColors
                                        .redPrimary, // para que parezca clickeable
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
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: "Registrarse",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // ✅ Solo entra si TODO es válido
                print("Correo: ${emailController.text}");
                print("Password: ${passwordController.text}");
                // Aquí llamas a tu lógica de login/registro
              }
            },
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
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: kInputDecoration.copyWith(hintText: hintText),
      validator: validator,
    );
  }
}
