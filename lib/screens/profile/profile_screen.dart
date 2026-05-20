import 'package:flutter/material.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/models/usuario.dart';
import 'package:reservapp_mobile/screens/auth/login_screen.dart';
import 'package:reservapp_mobile/services/auth_service.dart';
import 'package:reservapp_mobile/services/usuario_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usuarioService = UsuarioService();
  final _authService = AuthService();

  Usuario? _usuario;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    final id = await _authService.getUserId();
    if (id == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }
    final usuario = await _usuarioService.getUsuarioById(id);
    if (mounted) {
      setState(() {
        _usuario = usuario;
        _isLoading = false;
        _hasError = usuario == null;
      });
    }
  }

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _eliminarCuenta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción es irreversible. Se eliminarán todos tus datos y reservas. '
          '¿Quieres continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final confirmarFinal = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Estás completamente seguro?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, volver'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sí, eliminar mi cuenta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmarFinal != true || !mounted) return;

    final ok = await _usuarioService.deleteUsuario(_usuario!.id);
    if (!mounted) return;

    if (ok) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar la cuenta. Inténtalo más tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editarPerfil() async {
    if (_usuario == null) return;
    final actualizado = await Navigator.push<Usuario>(
      context,
      MaterialPageRoute(builder: (_) => _EditProfileScreen(usuario: _usuario!)),
    );
    if (actualizado != null) {
      setState(() => _usuario = actualizado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _usuario == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'No se pudo cargar el perfil',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _cargarPerfil,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
              const SizedBox(height: AppDimens.spacingMd),
              TextButton.icon(
                onPressed: _cerrarSesion,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final u = _usuario!;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _cargarPerfil,
      child: ListView(
        padding: AppDimens.screenPadding,
        children: [
          const SizedBox(height: AppDimens.spacingMd),

          // Nombre
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    u.iniciales,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  u.nombreCompleto,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                  ),
                  child: Text(
                    u.rol,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spacingXl),

          // Datos
          _SectionTitle('Datos personales'),
          const SizedBox(height: AppDimens.spacingSm),
          Card(
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.person_outline,
                  label: 'Nombre',
                  value: u.nombre,
                ),
                const Divider(height: 0, indent: 56),
                _InfoTile(
                  icon: Icons.badge_outlined,
                  label: 'Apellidos',
                  value: u.apellidos,
                ),
                const Divider(height: 0, indent: 56),
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Correo electrónico',
                  value: u.email,
                ),
                const Divider(height: 0, indent: 56),
                _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Teléfono',
                  value: u.telefono,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spacingLg),

          // Acciones
          _SectionTitle('Cuenta'),
          const SizedBox(height: AppDimens.spacingSm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Editar perfil'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: _editarPerfil,
                ),
                const Divider(height: 0, indent: 56),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: _cerrarSesion,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spacingMd),

          _SectionTitle('Zona de peligro'),
          const SizedBox(height: AppDimens.spacingSm),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Eliminar cuenta',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text(
                'Esta acción no se puede deshacer',
                style: TextStyle(fontSize: 12),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.red,
              ),
              onTap: _eliminarCuenta,
            ),
          ),

          const SizedBox(height: AppDimens.spacingXl),
        ],
      ),
    );
  }
}

// Editar
class _EditProfileScreen extends StatefulWidget {
  final Usuario usuario;
  const _EditProfileScreen({required this.usuario});

  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioService = UsuarioService();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidosCtrl;
  late final TextEditingController _telefonoCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.usuario.nombre);
    _apellidosCtrl = TextEditingController(text: widget.usuario.apellidos);
    _telefonoCtrl = TextEditingController(text: widget.usuario.telefono);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final actualizado = await _usuarioService.updateUsuario(
      Usuario(
        id: widget.usuario.id,
        nombre: _nombreCtrl.text.trim(),
        apellidos: _apellidosCtrl.text.trim(),
        email: widget.usuario.email,
        telefono: _telefonoCtrl.text.trim(),
        rol: widget.usuario.rol,
      ),
    );

    setState(() => _isSaving = false);
    if (!mounted) return;

    if (actualizado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
      Navigator.pop(context, actualizado);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar el perfil'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.spacingSm),
            child: TextButton(
              onPressed: _isSaving ? null : _guardar,
              child: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppDimens.screenPadding,
          children: [
            const SizedBox(height: AppDimens.spacingMd),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextFormField(
              controller: _apellidosCtrl,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextFormField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            // Email
            TextFormField(
              initialValue: widget.usuario.email,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                helperText: 'El correo no se puede modificar',
              ),
            ),
            const SizedBox(height: AppDimens.spacingXl),
            ElevatedButton(
              onPressed: _isSaving ? null : _guardar,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      dense: true,
    );
  }
}
