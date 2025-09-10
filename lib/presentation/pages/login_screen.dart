// login_page.dart
import 'package:flutter/material.dart';
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
                SizedBox(
                  width: 210,
                  child: const Text(
                    "Bienvenido de nuevo",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
          
                const SizedBox(height: 10),
          
                const Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    )
                ),
          
                const SizedBox(height: 20),
          
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Username@gmail.com',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F7), // gris claro
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // bordes redondeados
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
          
                const SizedBox(height: 30),
          
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue, // color del texto
                      side: const BorderSide(color: Colors.blue, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    ),
                    onPressed: () {
                      // Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      "Ir a Registrar",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
          
                const SizedBox(height: 200),
          
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white, // color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      elevation: 2, // efecto de sombra sutil
                    ),
                    onPressed: () {
                      // Acción al presionar
                      //Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    child: const Text(
                      "Entrar al Home",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}
