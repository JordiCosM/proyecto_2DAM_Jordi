import 'package:flutter/material.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/models/empresa.dart';
import 'package:reservapp_mobile/models/reserva.dart';
import 'package:reservapp_mobile/models/servicio.dart';
import 'package:reservapp_mobile/services/auth_service.dart';
import 'package:reservapp_mobile/services/empresa_service.dart';
import 'package:reservapp_mobile/services/reserva_service.dart';

class EmpresaDetailScreen extends StatefulWidget {
  final Empresa empresa;

  const EmpresaDetailScreen({super.key, required this.empresa});

  @override
  State<EmpresaDetailScreen> createState() => _EmpresaDetailScreenState();
}

class _EmpresaDetailScreenState extends State<EmpresaDetailScreen> {
  final _empresaService = EmpresaService();
  List<Servicio> _servicios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  Future<void> _cargarServicios() async {
    setState(() => _isLoading = true);
    final servicios = await _empresaService.getServiciosByEmpresa(
      widget.empresa.id,
    );
    if (mounted) {
      setState(() {
        _servicios = servicios;
        _isLoading = false;
      });
    }
  }

  void _reservar(Servicio servicio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (_) =>
          _ReservaSheet(servicio: servicio, empresa: widget.empresa),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empresa = widget.empresa;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                empresa.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                ),
              ),
              background: empresa.logoUrl != null && empresa.logoUrl!.isNotEmpty
                  ? Image.network(
                      empresa.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _LogoPlaceholder(nombre: empresa.nombre),
                    )
                  : _LogoPlaceholder(nombre: empresa.nombre),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sector
                  Chip(
                    label: Text(empresa.sector),
                    avatar: const Icon(
                      Icons.business_center_outlined,
                      size: 16,
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),

                  const SizedBox(height: AppDimens.spacingMd),

                  // Información de contacto
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: empresa.direccion,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(icon: Icons.phone_outlined, text: empresa.telefono),
                  const SizedBox(height: 6),
                  _InfoRow(icon: Icons.email_outlined, text: empresa.email),

                  const SizedBox(height: AppDimens.spacingLg),

                  // Descripción
                  Text(
                    'Descripción',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Text(
                    empresa.descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: AppDimens.spacingLg),

                  // Servicios
                  Text(
                    'Servicios',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                ],
              ),
            ),
          ),

          // Lista de servicios
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_servicios.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Text(
                  'Esta empresa no tiene servicios publicados.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spacingMd,
                0,
                AppDimens.spacingMd,
                80,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ServicioCard(
                    servicio: _servicios[i],
                    onReservar: () => _reservar(_servicios[i]),
                  ),
                  childCount: _servicios.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  final String nombre;
  const _LogoPlaceholder({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Text(
          nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class _ServicioCard extends StatelessWidget {
  final Servicio servicio;
  final VoidCallback onReservar;
  const _ServicioCard({required this.servicio, required this.onReservar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servicio.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (servicio.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      servicio.descripcion,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        servicio.formattedDuracion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        servicio.formattedPrecio,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onReservar,
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              child: const Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservaSheet extends StatefulWidget {
  final Servicio servicio;
  final Empresa empresa;
  const _ReservaSheet({required this.servicio, required this.empresa});

  @override
  State<_ReservaSheet> createState() => _ReservaSheetState();
}

class _ReservaSheetState extends State<_ReservaSheet> {
  final _reservaService = ReservaService();
  final _authService = AuthService();

  DateTime _fecha = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _horaInicio = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  TimeOfDay get _horaFin {
    final totalMinutos =
        _horaInicio.hour * 60 + _horaInicio.minute + widget.servicio.duracion;
    return TimeOfDay(
      hour: (totalMinutos ~/ 60) % 24,
      minute: totalMinutos % 60,
    );
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  String _formatFecha(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatFechaLegible(DateTime d) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${d.day} de ${meses[d.month - 1]} de ${d.year}';
  }

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _pickHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaInicio,
    );
    if (picked != null) setState(() => _horaInicio = picked);
  }

  Future<void> _confirmar() async {
    setState(() => _isLoading = true);

    final idUsuario = await _authService.getUserId();
    if (idUsuario == null) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de sesión. Vuelve a iniciar sesión.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final reserva = Reserva(
      id: 0,
      idUsuario: idUsuario,
      idServicio: widget.servicio.id,
      fecha: _formatFecha(_fecha),
      horaInicio: _formatTime(_horaInicio),
      horaFin: _formatTime(_horaFin),
      estado: EstadoReserva.pendiente,
      idEmpleados: [],
    );

    final result = await _reservaService.createReserva(reserva);
    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pop(context);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ Reserva creada para el ${_formatFechaLegible(_fecha)} '
            'a las ${_horaInicio.format(context)}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo crear la reserva. Inténtalo de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spacingMd,
              0,
              AppDimens.spacingMd,
              AppDimens.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Nueva reserva',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spacingSm),

                // Resumen
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.servicio.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.empresa.nombre,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${widget.servicio.formattedPrecio}  ·  ${widget.servicio.formattedDuracion}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spacingLg),

                // Selector fecha
                _SelectorTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha',
                  value: _formatFechaLegible(_fecha),
                  onTap: _pickFecha,
                ),
                const SizedBox(height: AppDimens.spacingSm),

                // Selector hora
                _SelectorTile(
                  icon: Icons.access_time_outlined,
                  label: 'Hora de inicio',
                  value: _horaInicio.format(context),
                  onTap: _pickHora,
                ),
                const SizedBox(height: AppDimens.spacingSm),

                // Hora fin
                _SelectorTile(
                  icon: Icons.timer_outlined,
                  label: 'Hora de fin (calculada)',
                  value: _horaFin.format(context),
                  onTap: null,
                ),

                const SizedBox(height: AppDimens.spacingLg),

                // Confirmar
                ElevatedButton(
                  onPressed: _isLoading ? null : _confirmar,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Confirmar reserva'),
                ),

                const SizedBox(height: AppDimens.spacingSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _SelectorTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingMd,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap != null
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: onTap != null ? null : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: onTap != null ? null : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
