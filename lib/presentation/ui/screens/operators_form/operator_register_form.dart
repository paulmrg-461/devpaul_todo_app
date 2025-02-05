import 'dart:typed_data';

import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:devpaul_todo_app/data/models/operator_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/operator_bloc/operator_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';

class OperatorRegisterForm extends StatefulWidget {
  static const String name = 'operator_register_form_screen';
  const OperatorRegisterForm({super.key});

  @override
  _OperatorRegisterFormState createState() => _OperatorRegisterFormState();
}

class _OperatorRegisterFormState extends State<OperatorRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  static const double _inputsWidth = 220;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _isSignatureLocked = false;
  void _toggleSignatureLock() {
    setState(() {
      _isSignatureLocked = !_isSignatureLocked;
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _dniController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Operador')),
      body: BlocListener<OperatorBloc, OperatorState>(
        listener: (context, state) {
          if (state is OperatorSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operador creado exitosamente')),
            );
            Navigator.pop(context);
          } else if (state is OperatorFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Nombres",
                  controller: _nameController,
                  validator: (value) => InputValidator.emptyValidator(
                    minCharacters: 3,
                    value: value,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.name,
                  icon: Icons.person_outline,
                  marginBottom: 4,
                ),
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Apellidos",
                  controller: _lastnameController,
                  validator: (value) => InputValidator.emptyValidator(
                    minCharacters: 3,
                    value: value,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.name,
                  icon: Icons.person_outline,
                  marginBottom: 4,
                ),
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Cédula",
                  controller: _dniController,
                  validator: (value) => InputValidator.numberValidator(value),
                  textInputType: TextInputType.number,
                  isNumeric: true,
                  icon: Icons.medical_information_outlined,
                  marginBottom: 4,
                ),
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Nombre de usuario",
                  controller: _usernameController,
                  validator: (value) => InputValidator.usernameValidator(value),
                  textCapitalization: TextCapitalization.none,
                  icon: Icons.person_outline,
                  marginBottom: 4,
                ),
                CustomInput(
                  width: 460,
                  hintText: "Contraseña",
                  controller: _passwordController,
                  validator: (value) =>
                      InputValidator.emptyValidator(value: value),
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  passwordVisibility: true,
                  marginBottom: 22,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 6),
                  child: Divider(),
                ),
                Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: _isSignatureLocked,
                      child: Signature(
                        controller: _signatureController,
                        width: screenWidth,
                        height: 210,
                        backgroundColor: Colors.grey[200]!,
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      top: 8,
                      child: Text('Firma operador:'),
                    ),
                    Positioned(
                      right: 6,
                      top: 0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _signatureController.clear(),
                            icon: const Icon(Icons.clear_rounded),
                            tooltip: 'Limpiar estado',
                          ),
                          IconButton(
                            onPressed:
                                _toggleSignatureLock, // Alternar el bloqueo
                            icon: Icon(
                              _isSignatureLocked
                                  ? Icons.lock_rounded
                                  : Icons.lock_open_rounded,
                              color: _isSignatureLocked
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            tooltip: _isSignatureLocked
                                ? 'Desbloquear Interacción'
                                : 'Bloquear Interacción',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _resetForm,
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_signatureController.isNotEmpty) {
                            final signature =
                                await _signatureController.toPngBytes();

                            _onSubmit(signature!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, firme el formulario'),
                              ),
                            );
                          }
                        }
                      },
                      label: const Text('Guardar'),
                      icon: const Icon(Icons.save_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(Uint8List signature) {
    if (_formKey.currentState!.validate()) {
      final UserModel operator = UserModel(
        id: '',
        name: _nameController.text,
        lastname: _lastnameController.text,
        email: '${(_usernameController.text).toLowerCase()}@diegolopez.com',
        dni: _dniController.text,
        signaturePhotoUrl: '',
        uid: '',
        token: '',
        password: _passwordController.text,
      );

      context.read<OperatorBloc>().add(
            CreateOperatorEvent(operator, signature),
          );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _lastnameController.clear();
      _usernameController.clear();
      _passwordController.clear();
      _dniController.clear();
      _signatureController.clear();
    });
    context.pop();
  }
}
