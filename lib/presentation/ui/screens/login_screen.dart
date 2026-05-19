import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/core/validators/input_validators.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      _focusNode.unfocus();
      context.read<AuthBloc>().add(
            AuthLoginEvent(
              _emailController.text.trim().toLowerCase(),
              _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop =
        MediaQuery.of(context).size.width >= AppBreakpoints.desktop;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorder,
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.primaryContainer.withAlpha(30),
                colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.huge,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final formWidth = constraints.maxWidth
                        .clamp(320.0, AppMaxWidth.form)
                        .toDouble();

                    if (isDesktop) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: formWidth,
                            child: _buildForm(context, textTheme, colorScheme),
                          ),
                          const SizedBox(width: AppSpacing.giant * 2),
                          Expanded(
                            child: _buildIllustration(context),
                          ),
                        ],
                      );
                    }

                    return _buildForm(context, textTheme, colorScheme);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Form(
      key: _formKey,
      child: StaggeredColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                image:
                    DecorationImage(image: const AssetImage('assets/logo.png')),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(80),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              // child: Center(
              //   child: Text(
              //     'D',
              //     style: textTheme.headlineLarge?.copyWith(
              //       color: colorScheme.onPrimary,
              //       fontWeight: FontWeight.w800,
              //     ),
              //   ),
              // ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Welcome back',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Sign in to continue with your tasks',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxxl),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
            validator: InputValidator.emailValidator,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onLoginPressed(),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                onPressed: () {},
              ),
            ),
            validator: (v) => InputValidator.emptyValidator(value: v),
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.huge),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: isLoading ? null : _onLoginPressed,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(isLoading ? 'Signing in...' : 'Sign in'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/user-register'),
                child: Text(
                  'Sign up',
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
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedFadeSlide(
      index: 0,
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 700),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460),
        padding: const EdgeInsets.all(AppSpacing.massive),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withAlpha(40),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: colorScheme.primaryContainer.withAlpha(60),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Organize your work\nwith AI-powered insights',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: AppFontScale.lineHeightTight,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Smart task management with real-time AI suggestions to help you stay productive and focused.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppFontScale.lineHeightRelaxed,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _featureChip(
                    context, Icons.psychology_outlined, 'AI Suggestions'),
                _featureChip(context, Icons.people_outline, 'Team Projects'),
                _featureChip(context, Icons.trending_up, 'Track Progress'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureChip(BuildContext context, IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.chipBorder,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
