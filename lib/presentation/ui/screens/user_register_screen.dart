import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:devpaul_todo_app/domain/entities/user.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';

class UserRegisterScreen extends StatefulWidget {
  static const String name = 'user_register_screen';
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _profileImageBytes = bytes);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Take a photo',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Choose from gallery',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill out the form correctly')),
      );
      return;
    }
    if (_profileImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile photo')),
      );
      return;
    }
    context.read<AuthBloc>().add(
          AuthRegisterEvent(
            User(
              name: _nameController.text.trim(),
              photoUrl: '',
              uid: '',
              email: _emailController.text.trim(),
              token: '',
              password: _passwordController.text.trim(),
              id: '',
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = (screenWidth - 48)
        .clamp(320.0, AppMaxWidth.form)
        .toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                final authUser = state.user;
                final newUser = User(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  id: authUser.id,
                  photoUrl: '',
                  uid: authUser.uid,
                  token: authUser.token,
                );
                context
                    .read<UserBloc>()
                    .add(CreateUserEvent(newUser, _profileImageBytes!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User ${newUser.name} created successfully"),
                    backgroundColor: AppColors.statusCompleted,
                  ),
                );
                context.go('/');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is OperatorFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surface,
                colorScheme.primaryContainer.withAlpha(25),
                colorScheme.surface,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.xxxl,
              ),
              child: SizedBox(
                width: formWidth,
                child: Form(
                  key: _formKey,
                  child: StaggeredColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Avatar picker
                      Center(
                        child: GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primaryContainer,
                              border: Border.all(
                                color: colorScheme.primary.withAlpha(60),
                                width: 2,
                              ),
                            ),
                            child: _profileImageBytes != null
                                ? ClipOval(
                                    child: Image.memory(
                                      _profileImageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          size: 28,
                                          color: colorScheme.primary),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Add photo',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // Name field
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon:
                              Icon(Icons.person_outline, size: 20),
                        ),
                        validator: (v) => InputValidator.emptyValidator(
                          minCharacters: 3,
                          value: v,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                              Icon(Icons.email_outlined, size: 20),
                        ),
                        validator: InputValidator.emailValidator,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onSubmit(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined,
                              size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.visibility_outlined,
                                size: 20),
                            onPressed: () {},
                          ),
                        ),
                        validator: (v) =>
                            InputValidator.emptyValidator(value: v),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),

                      // Register button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: isLoading ? null : _onSubmit,
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.person_add, size: 18),
                              label: Text(
                                  isLoading
                                      ? 'Creating account...'
                                      : 'Create account'),
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.xl,
                        ),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _formKey.currentState?.reset();
                              context.go('/login');
                            },
                            child: Text(
                              'Sign in',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
