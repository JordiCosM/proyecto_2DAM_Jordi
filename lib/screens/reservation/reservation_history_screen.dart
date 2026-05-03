import 'package:flutter/material.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/models/empresa.dart';
import 'package:reservapp_mobile/models/reserva.dart';
import 'package:reservapp_mobile/models/servicio.dart';
import 'package:reservapp_mobile/services/auth_service.dart';
import 'package:reservapp_mobile/services/empresa_service.dart';
import 'package:reservapp_mobile/services/reserva_service.dart';
import 'package:reservapp_mobile/services/servicio_service.dart';

class _ReservaDetalle {
  final Reserva reserva;
  final String nombreServicio;
  final String nombreEmpresa;

  const _ReservaDetalle({
    required this.reserva,
    required this.nombreServicio,
    required this.nombreEmpresa,
  });
}

class ReservationHistoryScreen extends StatefulWidget {
  const ReservationHistoryScreen({super.key});

  @override
  State<ReservationHistoryScreen> createState() =>
      _ReservationHistoryScreenState();
}

class _ReservationHistoryScreenState extends State<ReservationHistoryScreen>
    with SingleTickerProviderStateMixin {
  final _reservaService = ReservaService();
  final _servicioService = ServicioService();
  final _empresaService = EmpresaService();
  final _authService = AuthService();

  late final TabController _tabController;

  List<_ReservaDetalle> _todas = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final idUsuario = await _authService.getUserId();
      if (idUsuario == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      final results = await Future.wait([
        _reservaService.getReservasByUsuario(idUsuario),
        _servicioService.getAllServicios(),
        _empresaService.getEmpresas(),
      ]);

      final reservas = results[0] as List<Reserva>;
      final servicios = results[1] as List<Servicio>;
      final empresas = results[2] as List<Empresa>;

      final serviciosById = {for (final s in servicios) s.id: s};
      final empresasById = {for (final e in empresas) e.id: e};

      _todas = reservas.map((r) {
        final servicio = serviciosById[r.idServicio];
        final empresa = servicio != null
            ? empresasById[servicio.idEmpresa]
            : null;
        return _ReservaDetalle(
          reserva: r,
          nombreServicio: servicio?.nombre ?? 'Servicio #${r.idServicio}',
          nombreEmpresa: empresa?.nombre ?? '—',
        );
      }).toList();

      for (final d in _todas) {
        debugPrint(
          '  id:${d.reserva.id} '
          'fecha:"${d.reserva.fecha}" '
          'horaInicio:"${d.reserva.horaInicio}" '
          'dateTime:${d.reserva.dateTime} '
          'estado:${d.reserva.estado} '
          'isAfterNow:${d.reserva.dateTime.isAfter(DateTime.now())}',
        );
      }

      _todas.sort((a, b) => a.reserva.dateTime.compareTo(b.reserva.dateTime));

      setState(() => _isLoading = false);
    } catch (_) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  List<_ReservaDetalle> get _proximas => _todas
      .where(
        (d) =>
            d.reserva.dateTime.isAfter(DateTime.now()) &&
            d.reserva.estado != EstadoReserva.cancelada &&
            d.reserva.estado != EstadoReserva.finalizada,
      )
      .toList();

  List<_ReservaDetalle> get _historial => _todas
      .where(
        (d) =>
            d.reserva.dateTime.isBefore(DateTime.now()) ||
            d.reserva.estado == EstadoReserva.cancelada ||
            d.reserva.estado == EstadoReserva.finalizada,
      )
      .toList()
      .reversed
      .toList();

  Future<void> _cancelar(_ReservaDetalle detalle) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text(
          '¿Seguro que quieres cancelar "${detalle.nombreServicio}" '
          'en ${detalle.nombreEmpresa}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sí, cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final ok = await _reservaService.cancelarReserva(detalle.reserva.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Reserva cancelada' : 'No se pudo cancelar. Inténtalo de nuevo.',
        ),
        backgroundColor: ok ? null : Colors.red,
      ),
    );
    if (ok) _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reservas'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Próximas'),
                  if (!_isLoading && _proximas.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _CountBadge(count: _proximas.length),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Historial'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              const Text(
                'No se pudieron cargar tus reservas',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _cargarDatos,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildLista(_proximas, empty: _EmptyState.proximas),
          _buildLista(_historial, empty: _EmptyState.historial),
        ],
      ),
    );
  }

  Widget _buildLista(
    List<_ReservaDetalle> lista, {
    required _EmptyState empty,
  }) {
    if (lista.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: _EmptyPlaceholder(state: empty),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      itemCount: lista.length,
      itemBuilder: (context, i) => _ReservaCard(
        detalle: lista[i],
        onCancelar:
            (lista[i].reserva.estado == EstadoReserva.pendiente ||
                lista[i].reserva.estado == EstadoReserva.confirmada)
            ? () => _cancelar(lista[i])
            : null,
      ),
    );
  }
}

// Tarjeta reserva
class _ReservaCard extends StatelessWidget {
  final _ReservaDetalle detalle;
  final VoidCallback? onCancelar;

  const _ReservaCard({required this.detalle, this.onCancelar});

  @override
  Widget build(BuildContext context) {
    final r = detalle.reserva;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre y estado
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    detalle.nombreServicio,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _EstadoBadge(estado: r.estado),
              ],
            ),
            const SizedBox(height: 6),

            // Empresa
            _Row(icon: Icons.business_outlined, text: detalle.nombreEmpresa),
            const SizedBox(height: 4),

            // Fecha
            _Row(
              icon: Icons.calendar_today_outlined,
              text: _formatFecha(r.dateTime),
            ),
            const SizedBox(height: 4),

            // Horario
            _Row(
              icon: Icons.access_time_outlined,
              text:
                  '${r.horaInicio.substring(0, 5)} – ${r.horaFin.substring(0, 5)}',
            ),

            // Cancelar
            if (onCancelar != null) ...[
              const Divider(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onCancelar,
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 18,
                  ),
                  label: const Text(
                    'Cancelar reserva',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime dt) {
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${dt.day} ${meses[dt.month - 1]} ${dt.year}';
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Estado
class _EstadoBadge extends StatelessWidget {
  final EstadoReserva estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (estado) {
      EstadoReserva.confirmada => (Colors.green, Icons.check_circle_outline),
      EstadoReserva.cancelada => (Colors.red, Icons.cancel_outlined),
      EstadoReserva.finalizada => (Colors.purple, Icons.done_all),
      EstadoReserva.pendiente => (Colors.orange, Icons.schedule),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            estado.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

enum _EmptyState { proximas, historial }

class _EmptyPlaceholder extends StatelessWidget {
  final _EmptyState state;
  const _EmptyPlaceholder({required this.state});

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = switch (state) {
      _EmptyState.proximas => (
        Icons.event_available_outlined,
        'Sin reservas próximas',
        'Explora empresas y haz tu primera reserva',
      ),
      _EmptyState.historial => (
        Icons.history,
        'Sin historial aún',
        'Aquí aparecerán tus reservas pasadas',
      ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
