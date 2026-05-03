import 'package:flutter/material.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/models/empresa.dart';
import 'package:reservapp_mobile/models/horario.dart';
import 'package:reservapp_mobile/models/reserva.dart';
import 'package:reservapp_mobile/models/servicio.dart';
import 'package:reservapp_mobile/services/auth_service.dart';
import 'package:reservapp_mobile/services/disponibilidad_service.dart';
import 'package:reservapp_mobile/services/empresa_service.dart';
import 'package:reservapp_mobile/services/horario_service.dart';
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
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (_) =>
          _ReservaSheet(servicio: servicio, empresa: widget.empresa),
    );
  }

  void _verImagen(String url, List<String> todas, int indice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _GaleriaViewer(urls: todas, indiceInicial: indice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empresa = widget.empresa;
    final theme = Theme.of(context);
    final imagenesAbs = empresa.imagenesAbsolutas;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: empresa.logoUrlAbsoluta != null
                        ? Image.network(
                            empresa.logoUrlAbsoluta!,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _LogoMini(nombre: empresa.nombre),
                          )
                        : _LogoMini(nombre: empresa.nombre),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      empresa.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _AppBarBackground(empresa: empresa),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
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

                  // Datos de contacto
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

                  // Galería
                  if (imagenesAbs.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spacingLg),
                    Text(
                      'Imágenes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacingSm),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagenesAbs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () =>
                              _verImagen(imagenesAbs[i], imagenesAbs, i),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMd,
                            ),
                            child: Image.network(
                              imagenesAbs[i],
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 110,
                                height: 110,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppDimens.spacingLg),
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
                32,
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

class _GaleriaViewer extends StatefulWidget {
  final List<String> urls;
  final int indiceInicial;

  const _GaleriaViewer({required this.urls, required this.indiceInicial});

  @override
  State<_GaleriaViewer> createState() => _GaleriaViewerState();
}

class _GaleriaViewerState extends State<_GaleriaViewer> {
  late final PageController _ctrl;
  late int _indice;

  @override
  void initState() {
    super.initState();
    _indice = widget.indiceInicial;
    _ctrl = PageController(initialPage: widget.indiceInicial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_indice + 1} / ${widget.urls.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _ctrl,
        itemCount: widget.urls.length,
        onPageChanged: (i) => setState(() => _indice = i),
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: Image.network(
              widget.urls[i],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
                size: 64,
              ),
            ),
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
  final _horarioService = HorarioService();
  final _authService = AuthService();

  List<Horario> _horarios = [];
  List<Reserva> _reservas = [];
  bool _loadingDatos = true;

  late int _mesAnio;
  late int _mes;
  String? _fechaSeleccionada;
  String? _slotSeleccionado;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _mesAnio = now.year;
    _mes = now.month;
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _loadingDatos = true);
    final results = await Future.wait([
      _horarioService.getHorariosByEmpresa(widget.empresa.id),
      _reservaService.getReservasByServicio(widget.servicio.id),
    ]);
    if (mounted) {
      setState(() {
        _horarios = results[0] as List<Horario>;
        _reservas = results[1] as List<Reserva>;
        _loadingDatos = false;
      });
    }
  }

  List<SlotInfo> get _slotsDelDia {
    if (_fechaSeleccionada == null) return [];
    return DisponibilidadService.getSlotsForDate(
      horarios: _horarios,
      reservas: _reservas,
      servicio: widget.servicio,
      fecha: _fechaSeleccionada!,
    );
  }

  String? get _horaFin {
    if (_slotSeleccionado == null) return null;
    final parts = _slotSeleccionado!.split(':');
    final total =
        int.parse(parts[0]) * 60 +
        int.parse(parts[1]) +
        widget.servicio.duracion;
    return '${(total ~/ 60).toString().padLeft(2, '0')}:${(total % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _confirmar() async {
    if (_fechaSeleccionada == null || _slotSeleccionado == null) return;
    setState(() => _isBooking = true);

    final idUsuario = await _authService.getUserId();
    if (idUsuario == null) {
      setState(() => _isBooking = false);
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
      fecha: _fechaSeleccionada!,
      horaInicio: '$_slotSeleccionado:00',
      horaFin: '$_horaFin:00',
      estado: EstadoReserva.pendiente,
      idEmpleados: [],
    );

    final result = await _reservaService.createReserva(reserva);
    setState(() => _isBooking = false);
    if (!mounted) return;

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result != null
              ? '✅ Reserva creada el $_fechaSeleccionada a las $_slotSeleccionado'
              : 'No se pudo crear la reserva. Inténtalo de nuevo.',
        ),
        backgroundColor: result != null ? null : Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(
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
              AppDimens.spacingSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nueva reserva',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.servicio.nombre} · ${widget.servicio.formattedPrecio} · ${widget.servicio.formattedDuracion}',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loadingDatos
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.all(AppDimens.spacingMd),
                    children: [
                      _CalendarioWidget(
                        anio: _mesAnio,
                        mes: _mes,
                        horarios: _horarios,
                        reservas: _reservas,
                        servicio: widget.servicio,
                        fechaSeleccionada: _fechaSeleccionada,
                        onMesAnterior: () => setState(() {
                          final d = DateTime(_mesAnio, _mes - 1, 1);
                          _mesAnio = d.year;
                          _mes = d.month;
                          _fechaSeleccionada = null;
                          _slotSeleccionado = null;
                        }),
                        onMesSiguiente: () => setState(() {
                          final d = DateTime(_mesAnio, _mes + 1, 1);
                          _mesAnio = d.year;
                          _mes = d.month;
                          _fechaSeleccionada = null;
                          _slotSeleccionado = null;
                        }),
                        onSelectFecha: (f) => setState(() {
                          _fechaSeleccionada = f;
                          _slotSeleccionado = null;
                        }),
                      ),
                      if (_fechaSeleccionada != null) ...[
                        const SizedBox(height: AppDimens.spacingLg),
                        Text(
                          _formatFechaLegible(_fechaSeleccionada!),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spacingSm),
                        _SlotsWidget(
                          slots: _slotsDelDia,
                          slotSeleccionado: _slotSeleccionado,
                          onSelect: (h) =>
                              setState(() => _slotSeleccionado = h),
                        ),
                        if (_slotSeleccionado != null) ...[
                          const SizedBox(height: AppDimens.spacingSm),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'De $_slotSeleccionado a $_horaFin',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                      const SizedBox(height: AppDimens.spacingXl),
                      ElevatedButton(
                        onPressed: (_slotSeleccionado == null || _isBooking)
                            ? null
                            : _confirmar,
                        child: _isBooking
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
                      const SizedBox(height: AppDimens.spacingMd),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _formatFechaLegible(String fecha) {
    final dt = DateTime.parse('${fecha}T00:00:00');
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
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return '${dias[dt.weekday - 1]}, ${dt.day} de ${meses[dt.month - 1]}';
  }
}

class _CalendarioWidget extends StatelessWidget {
  final int anio;
  final int mes;
  final List<Horario> horarios;
  final List<Reserva> reservas;
  final Servicio servicio;
  final String? fechaSeleccionada;
  final VoidCallback onMesAnterior;
  final VoidCallback onMesSiguiente;
  final ValueChanged<String> onSelectFecha;

  static const _diasNombre = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  const _CalendarioWidget({
    required this.anio,
    required this.mes,
    required this.horarios,
    required this.reservas,
    required this.servicio,
    required this.fechaSeleccionada,
    required this.onMesAnterior,
    required this.onMesSiguiente,
    required this.onSelectFecha,
  });

  String _toFecha(int dia) =>
      '$anio-${mes.toString().padLeft(2, '0')}-${dia.toString().padLeft(2, '0')}';

  int get _offsetInicio => (DateTime(anio, mes, 1).weekday - 1) % 7;
  int get _diasEnMes => DateTime(anio, mes + 1, 0).day;

  bool _esHoy(int dia) {
    final hoy = DateTime.now();
    return hoy.year == anio && hoy.month == mes && hoy.day == dia;
  }

  static String _nombreMes(int m) => [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ][m - 1];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onMesAnterior,
              icon: const Icon(Icons.chevron_left),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                '${_nombreMes(mes)} $anio',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(
              onPressed: onMesSiguiente,
              icon: const Icon(Icons.chevron_right),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: _diasNombre
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemCount: _offsetInicio + _diasEnMes,
          itemBuilder: (context, i) {
            if (i < _offsetInicio) return const SizedBox();
            final dia = i - _offsetInicio + 1;
            final fecha = _toFecha(dia);
            final estado = DisponibilidadService.getEstadoDia(
              horarios: horarios,
              reservas: reservas,
              servicio: servicio,
              fecha: fecha,
            );
            final seleccionado = fechaSeleccionada == fecha;
            final esHoy = _esHoy(dia);
            final clickable = estado == EstadoDia.disponible;

            Color bgColor;
            Color textColor;
            BoxBorder? border;

            if (seleccionado) {
              bgColor = theme.colorScheme.primary;
              textColor = Colors.white;
              border = null;
            } else {
              switch (estado) {
                case EstadoDia.disponible:
                  bgColor = const Color(0xFFDCFCE7);
                  textColor = const Color(0xFF166534);
                  border = Border.all(color: const Color(0xFF4ADE80));
                case EstadoDia.lleno:
                  bgColor = const Color(0xFFFEE2E2);
                  textColor = const Color(0xFF991B1B);
                  border = null;
                case EstadoDia.cerrado:
                  bgColor = const Color(0xFFF3F4F6);
                  textColor = Colors.grey;
                  border = null;
                case EstadoDia.pasado:
                  bgColor = Colors.transparent;
                  textColor = Colors.grey[300]!;
                  border = null;
              }
            }

            if (esHoy && !seleccionado) {
              border = Border.all(color: theme.colorScheme.primary, width: 2);
            }

            return GestureDetector(
              onTap: clickable ? () => onSelectFecha(fecha) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  border: border,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$dia',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: (esHoy || seleccionado)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimens.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LeyendaItem(
              color: const Color(0xFFDCFCE7),
              border: const Color(0xFF4ADE80),
              label: 'Disponible',
            ),
            const SizedBox(width: 12),
            _LeyendaItem(
              color: const Color(0xFFFEE2E2),
              border: const Color(0xFFFCA5A5),
              label: 'Sin plazas',
            ),
            const SizedBox(width: 12),
            _LeyendaItem(
              color: const Color(0xFFF3F4F6),
              border: Colors.grey,
              label: 'Cerrado',
            ),
          ],
        ),
      ],
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final Color border;
  final String label;
  const _LeyendaItem({
    required this.color,
    required this.border,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _SlotsWidget extends StatelessWidget {
  final List<SlotInfo> slots;
  final String? slotSeleccionado;
  final ValueChanged<String> onSelect;

  const _SlotsWidget({
    required this.slots,
    required this.slotSeleccionado,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Text(
        'No hay horarios disponibles para este día.',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      );
    }

    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots.map((slot) {
        final seleccionado = slotSeleccionado == slot.hora;
        final Color bg;
        final Color text;
        final BoxBorder? border;

        if (seleccionado) {
          bg = theme.colorScheme.primary;
          text = Colors.white;
          border = null;
        } else if (!slot.disponible) {
          bg = Colors.grey[200]!;
          text = Colors.grey[400]!;
          border = null;
        } else {
          bg = const Color(0xFFDCFCE7);
          text = const Color(0xFF166534);
          border = Border.all(color: const Color(0xFF4ADE80));
        }

        return GestureDetector(
          onTap: slot.disponible ? () => onSelect(slot.hora) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              border: border,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Text(
              slot.hora,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: text,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  final Empresa empresa;
  const _AppBarBackground({required this.empresa});

  @override
  Widget build(BuildContext context) {
    final bgUrl = empresa.imagenesAbsolutas.isNotEmpty
        ? empresa.imagenesAbsolutas.first
        : empresa.logoUrlAbsoluta;

    if (bgUrl != null) {
      return Image.network(
        bgUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _ColorBackground(nombre: empresa.nombre),
      );
    }
    return _ColorBackground(nombre: empresa.nombre);
  }
}

class _ColorBackground extends StatelessWidget {
  final String nombre;
  const _ColorBackground({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Text(
          nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}

class _LogoMini extends StatelessWidget {
  final String nombre;
  const _LogoMini({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
