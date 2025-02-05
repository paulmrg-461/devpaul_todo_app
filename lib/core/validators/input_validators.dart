class InputValidator {
  static String? emptyValidator({String? value, int? minCharacters = 6}) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';
    if (value.length < minCharacters!) {
      return 'Debe contener mínimo $minCharacters caracteres';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';
    final emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegExp.hasMatch(value)) return 'Formato de correo no válido';

    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9._-]+$');

    if (!usernameRegExp.hasMatch(value)) {
      return 'El nombre de usuario solo puede contener letras, números, guiones bajos, guiones y puntos, sin espacios.';
    }

    if (value.length < 3 || value.length > 20) {
      return 'El nombre de usuario debe tener entre 3 y 20 caracteres.';
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-.,!@#\$&*~]).{8,}$');

    if (!passwordRegExp.hasMatch(value)) {
      return 'Debe contener: 1 mayúscula, 1 Minúscula, 1 caracter especial, mínimo 8 caracteres';
    }

    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';

    final numberRegExp = RegExp(r'^-?\d+(\.\d+)?$');

    if (!numberRegExp.hasMatch(value)) {
      return 'Debe ser un número válido';
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';

    if (value.length < 6) {
      return 'Debe contener mínimo 6 caracteres';
    }

    if (double.tryParse(value) == null) {
      return 'Debe ser un número';
    }

    return null;
  }

  static String? numberLengthValidator(String? value, int length) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.trim().isEmpty) return 'Campo requerido';

    if (double.tryParse(value) == null) {
      return 'El campo debe ser numérico';
    }

    if (value.length < length) {
      return 'Debe contener al menos $length caracteres';
    }

    return null;
  }

  static String? licensePlateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }

    // Expresión regular para los formatos válidos: ABC12 o ABC12A
    final licensePlateRegExp = RegExp(r'^[A-Z]{3}\d{2}[A-Z]?$');

    if (!licensePlateRegExp.hasMatch(value)) {
      return 'Placa no válida. Formato permitido: ABC12 o ABC12A';
    }

    return null;
  }
}
