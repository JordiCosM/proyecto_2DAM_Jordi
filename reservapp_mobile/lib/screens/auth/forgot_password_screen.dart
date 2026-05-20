import 'package:flutter/material.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/services/auth_service.dart';

enum _Step { email, reset, done }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _authService = AuthService();

  _Step _step = _Step.email;
  bool _isLoading = false;

  final _emailFormKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  final _resetFormKey = GlobalKey<FormState>();
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestToken() async {
    if (!_emailFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await _authService.forgotPassword(_emailCtrl.text.trim());

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (success) {
      setState(() => _step = _Step.reset);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo conectar con el servidor. Inténtalo de nuevo.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_resetFormKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await _authService.resetPassword(
      token: _tokenCtrl.text.trim(),
      newPassword: _passwordCtrl.text.trim(),
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (success) {
      setState(() => _step = _Step.done);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El token no es válido o ha expirado. Solicita uno nuevo.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SingleChildScrollView(
        padding: AppDimens.screenPadding,
        child: switch (_step) {
          _Step.email => _buildEmailStep(),
          _Step.reset => _buildResetStep(),
          _Step.done => _buildDoneStep(),
        },
      ),
    );
  }

  Widget _buildEmailStep() {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spacingLg),
          Icon(
            Icons.lock_reset_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Text(
            '¿Olvidaste tu contraseña?',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          const Text(
            'Introduce tu correo y el administrador verá el token en los logs del servidor.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppDimens.spacingXl),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ingresa tu correo';
              if (!v.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spacingLg),
          ElevatedButton(
            onPressed: _isLoading ? null : _requestToken,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Solicitar token'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetStep() {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spacingLg),
          Icon(
            Icons.vpn_key_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Text(
            'Introduce el token',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            'Copia el token de los logs del servidor para ${_emailCtrl.text.trim()} e introdúcelo aquí. Expira en 15 minutos.',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppDimens.spacingXl),

          TextFormField(
            controller: _tokenCtrl,
            decoration: const InputDecoration(
              labelText: 'Token de recuperación',
              prefixIcon: Icon(Icons.token_outlined),
              helperText:
                  'UUID con el formato: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Introduce el token';
              final uuidRegex = RegExp(
                r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
              );
              if (!uuidRegex.hasMatch(v.trim())) {
                return 'Formato de token inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spacingMd),

          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Nueva contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Introduce una contraseña';
              if (v.length < 8) return 'Mínimo 8 caracteres';
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spacingMd),

          TextFormField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Confirma tu contraseña';
              if (v != _passwordCtrl.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spacingLg),

          ElevatedButton(
            onPressed: _isLoading ? null : _resetPassword,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Cambiar contraseña'),
          ),
          const SizedBox(height: AppDimens.spacingMd),

          Center(
            child: TextButton(
              onPressed: () => setState(() {
                _step = _Step.email;
                _tokenCtrl.clear();
                _passwordCtrl.clear();
                _confirmCtrl.clear();
              }),
              child: const Text('Solicitar un nuevo token'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneStep() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimens.spacingXl),
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: AppDimens.spacingLg),
          Text(
            'Contraseña actualizada',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          const Text(
            'Ya puedes iniciar sesión con tu nueva contraseña.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppDimens.spacingXl),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ir a iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
