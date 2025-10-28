// register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordena_ya/core/app_routes.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/constants/app_styles.dart';
import 'package:ordena_ya/core/utils/validators.dart';
import 'package:ordena_ya/data/model/register_user_model.dart';
import 'package:ordena_ya/presentation/pages/login_screen.dart';
import 'package:ordena_ya/presentation/providers/user_provider.dart';
import 'package:ordena_ya/presentation/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
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

  void clearFormFields() {
    setState(() {
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      firstNameController.clear();
      lastNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool loading = context.watch<UserProvider>().loading;
    return LoadingOverlay(
      isLoading: loading,
      child: Consumer<UserProvider>(
        builder: (context, value, child) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (!value.loading &&
                value.error != null &&
                value.error!.isNotEmpty) {
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Error', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      content: Text(value.error!, style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<UserProvider>().setError(null);
                            Navigator.pop(context);
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      backgroundColor: AppColors.redPrimary,
                    ),
              );
            }

            if (!value.loading && value.user != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => AlertDialog(
                      title: const Text('¡Usuario creado!', style: TextStyle(fontWeight: FontWeight.bold)),
                      content: const Text(
                        'Tu cuenta ha sido creada con éxito.',
                        style: TextStyle(color: AppColors.textSecundary)
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            value.clearUser();
                            clearFormFields();
                            Navigator.pop(context);
                            // Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          child: const Text('OK', style: TextStyle(color: AppColors.redPrimary)),
                        ),
                      ],
                      backgroundColor: Colors.white,
                    ),
              );
            }
          });

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
                              (value) => CustomValidators.name(
                                value,
                                fieldName: "Nombre",
                              ),
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
                                  const TextSpan(
                                    text: "¿Ya tienes una cuenta? ",
                                  ),
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
                      RegisterUserModel request = RegisterUserModel(
                        username: usernameController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        tenantId: 1,
                        role: "waiter",
                      );
                      context.read<UserProvider>().register(request);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.maxLength,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: kInputDecoration.copyWith(hintText: hintText, counterText: ''),
      validator: validator,
    );
  }
}
