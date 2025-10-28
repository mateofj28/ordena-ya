class CustomValidators {
  static String? required(String? value, {String fieldName = "Este campo"}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? phone(
    String? value, {
    String fieldName = "Número de celular",
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    final cleaned = value.replaceAll(
      RegExp(r'\D'),
      '',
    ); // elimina todo menos números

    if (cleaned.length != 10) {
      return 'Debe tener exactamente 10 dígitos';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return '$fieldName solo puede contener números';
    }

    // Validación adicional para números de celular colombianos (opcional)
    // Los celulares en Colombia generalmente empiezan con 3
    if (!cleaned.startsWith('3')) {
      return 'Debe comenzar con 3 (formato colombiano)';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Formato de correo inválido';
    }

    return null;
  }

  static String? password(
    String? value, {
    String fieldName = "Contraseña",
    int minLength = 8,
    bool requireUppercase = true,
    bool requireDigits = true,
    bool requireSpecial = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    /*if (value.length < minLength) {
      return 'Debe tener $minLength caracteres';
    }

    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Al menos una letra mayúscula debe contener';
    }*/

    /*if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Al menos una letra minúscula debe contener';
    }

    if (requireDigits && !RegExp(r'\d').hasMatch(value)) {
      return 'Al menos un número debe contener';
    }

    if (requireSpecial &&
        !RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:"\\|,.<>\/\?~`]').hasMatch(value)) {
      return '$fieldName debe contener al menos un carácter especial';
    }*/

    return null; // todo OK
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre de usuario es requerido';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9._-]{3,15}$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Debe tener 3-15 caracteres y solo puede contener letras, números, puntos o guiones.';
    }
    return null;
  }

  static String? name(String? value, {String fieldName = "Nombre"}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    final nameRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Solo se permiten letras en $fieldName';
    }
    return null;
  }
}
