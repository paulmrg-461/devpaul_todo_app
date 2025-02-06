import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Permite elegir la imagen de perfil ya sea desde cámara o galería.
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

  /// Muestra las opciones para seleccionar imagen (cámara o galería).
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Register')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is OperatorSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User created successfully')),
            );
            Navigator.pop(context);
          } else if (state is OperatorFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Widget para seleccionar foto de perfil.
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
                const SizedBox(height: 20),
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
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill out the form correctly'),
                        ),
                      );
                      return;
                    }
                    if (_profileImageBytes == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a profile photo'),
                        ),
                      );
                      return;
                    }
                    _onSubmit(_profileImageBytes!);
                  },
                  label: const Text('Register'),
                  icon: const Icon(Icons.save_outlined),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, top: 22),
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

  void _onSubmit(Uint8List photoBytes) {
    if (_formKey.currentState!.validate()) {
      final UserModel user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        id: '',
        photoUrl: '',
        uid: '',
        token: '',
      );

      context.read<UserBloc>().add(
            CreateUserEvent(user, photoBytes),
          );
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _profileImageBytes = null;
    });
    context.pop();
  }
}
