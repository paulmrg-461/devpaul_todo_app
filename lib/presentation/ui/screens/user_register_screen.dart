import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/widgets.dart';

class UserRegisterScreen extends StatefulWidget {
  static const String name = 'user_register_screen';
  const UserRegisterScreen({super.key});

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  static const double _inputsWidth = 220;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  /// Flag para evitar que se intente registrar más de una vez.
  bool _userCreated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Selecciona la imagen de perfil desde cámara o galería.
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
      });
    }
  }

  /// Muestra las opciones para seleccionar imagen.
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Valida el formulario y dispara el evento de registro en AuthBloc.
  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out the form correctly')),
      );
      return;
    }
    if (_profileImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile photo')),
      );
      return;
    }
    // Dispara el evento para registrar al usuario (sólo se usan email y password).
    context.read<AuthBloc>().add(
          AuthRegisterEvent(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          ),
        );
  }

  /// Reinicia el formulario.
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _profileImageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listener para AuthBloc: al autenticarse correctamente, se crea el registro en Firestore.
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              if (!_userCreated) {
                _userCreated = true;
                final authUser = state.user;
                final newUser = UserModel(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  id: authUser.id, // O usa authUser.uid según tu lógica.
                  photoUrl: '', // Se actualizará tras la subida de la imagen.
                  uid: authUser.uid,
                  token: authUser.token,
                );
                // Crea el registro en Firestore y sube la foto de perfil.
                context
                    .read<UserBloc>()
                    .add(CreateUserEvent(newUser, _profileImageBytes!));
              }
              // Una vez completado el proceso, navega a la pantalla Home.
              context.go('/');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        // Listener para UserBloc: muestra errores al crear el registro en Firestore.
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is OperatorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('User Register')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Selector de foto de perfil.
                Center(
                  child: GestureDetector(
                    onTap: _showImageSourceActionSheet,
                    child: CircleAvatar(
                      radius: 76,
                      backgroundImage: _profileImageBytes != null
                          ? MemoryImage(_profileImageBytes!)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                      child: _profileImageBytes == null
                          ? const Icon(Icons.add_a_photo,
                              size: 38, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Full name",
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
                  hintText: "Email",
                  controller: _emailController,
                  validator: (value) => InputValidator.emailValidator(value),
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  marginBottom: 4,
                ),
                CustomInput(
                  width: _inputsWidth,
                  hintText: "Password",
                  controller: _passwordController,
                  validator: (value) =>
                      InputValidator.emptyValidator(value: value),
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  passwordVisibility: true,
                  marginBottom: 22,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _onSubmit,
                  label: const Text('Register'),
                  icon: const Icon(Icons.save_outlined),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 26),
                  child: Divider(),
                ),
                TextButton(
                  onPressed: () {
                    _resetForm();
                    context.go('/login');
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
