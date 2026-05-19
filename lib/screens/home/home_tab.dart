import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reservapp_mobile/components/empresa_card.dart';
import 'package:reservapp_mobile/config/app_theme.dart';
import 'package:reservapp_mobile/models/ciudad.dart';
import 'package:reservapp_mobile/models/empresa.dart';
import 'package:reservapp_mobile/services/ciudad_service.dart';
import 'package:reservapp_mobile/services/empresa_service.dart';
import 'package:reservapp_mobile/screens/empresa/empresa_detail_screen.dart';

const _kPageSize = 12;

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _empresaService = EmpresaService();
  final _ciudadService = CiudadService();

  List<Empresa> _todasEmpresas = [];
  Map<int, Ciudad> _ciudadesById = {}; // id → Ciudad

  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _sectorFiltro;
  int? _ciudadFiltro;

  int _paginaActual = 0;
  List<Empresa> _empresasFiltradas = [];
  List<Empresa> _empresasVisibles = [];
  bool _hayMas = false;

  bool _isLoading = true;
  bool _hasError = false;

  List<String> _sectores = [];

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    _cargarDatos();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final results = await Future.wait([
        _empresaService.getEmpresas(),
        _ciudadService.getCiudades(),
      ]);

      final empresas = results[0] as List<Empresa>;
      final ciudades = results[1] as List<Ciudad>;

      _ciudadesById = {for (final c in ciudades) c.id: c};

      // Sectores
      _sectores =
          empresas
              .map((e) => e.sector)
              .where((s) => s.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

      _todasEmpresas = empresas;
      _aplicarFiltros();
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Filtrado y paginación
  void _aplicarFiltros() {
    final q = _query.toLowerCase().trim();

    _empresasFiltradas = _todasEmpresas.where((e) {
      // Filtro de texto
      if (q.isNotEmpty) {
        final ciudad = _ciudadesById[e.idCiudad]?.nombre.toLowerCase() ?? '';
        final coincide =
            e.nombre.toLowerCase().contains(q) ||
            e.descripcion.toLowerCase().contains(q) ||
            e.sector.toLowerCase().contains(q) ||
            e.direccion.toLowerCase().contains(q) ||
            ciudad.contains(q);
        if (!coincide) return false;
      }

      // Filtro de sector
      if (_sectorFiltro != null && e.sector != _sectorFiltro) return false;

      // Filtro de ciudad
      if (_ciudadFiltro != null && e.idCiudad != _ciudadFiltro) return false;

      return true;
    }).toList();

    // Paginación
    _paginaActual = 0;
    _empresasVisibles = _empresasFiltradas.take(_kPageSize).toList();
    _hayMas = _empresasFiltradas.length > _kPageSize;

    setState(() {});
  }

  void _cargarMas() {
    _paginaActual++;
    final inicio = _paginaActual * _kPageSize;
    final fin = inicio + _kPageSize;
    final nuevas = _empresasFiltradas.sublist(
      inicio,
      fin.clamp(0, _empresasFiltradas.length),
    );
    setState(() {
      _empresasVisibles.addAll(nuevas);
      _hayMas = fin < _empresasFiltradas.length;
    });
  }

  void _onScroll() {
    if (_hayMas &&
        _scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 200) {
      _cargarMas();
    }
  }

  // Búsqueda
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _query = value;
      _aplicarFiltros();
    });
  }

  // Filtros
  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLg),
        ),
      ),
      builder: (_) => _FiltrosSheet(
        sectores: _sectores,
        ciudades: _ciudadesById.values.toList()
          ..sort((a, b) => a.nombre.compareTo(b.nombre)),
        sectorSeleccionado: _sectorFiltro,
        ciudadSeleccionada: _ciudadFiltro,
        onApply: (sector, ciudad) {
          setState(() {
            _sectorFiltro = sector;
            _ciudadFiltro = ciudad;
          });
          _aplicarFiltros();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrosActivos =
        (_sectorFiltro != null ? 1 : 0) + (_ciudadFiltro != null ? 1 : 0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spacingMd,
                AppDimens.spacingMd,
                AppDimens.spacingMd,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¿Qué necesitas hoy?',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppDimens.spacingMd),

                  //Búsqueda y filtros
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Buscar empresas, servicios, ciudades…',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      _query = '';
                                      _aplicarFiltros();
                                    },
                                  )
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Badge(
                        isLabelVisible: filtrosActivos > 0,
                        label: Text('$filtrosActivos'),
                        child: IconButton.filledTonal(
                          onPressed: _abrirFiltros,
                          icon: const Icon(Icons.tune),
                          tooltip: 'Filtros',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spacingSm),

                  // Sector
                  if (_sectores.isNotEmpty)
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sectores.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 6),
                        itemBuilder: (_, i) {
                          final s = _sectores[i];
                          final sel = _sectorFiltro == s;
                          return FilterChip(
                            label: Text(
                              s,
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: sel,
                            visualDensity: VisualDensity.compact,
                            onSelected: (_) {
                              setState(() => _sectorFiltro = sel ? null : s);
                              _aplicarFiltros();
                            },
                          );
                        },
                      ),
                    ),

                  if (!_isLoading) ...[
                    const SizedBox(height: AppDimens.spacingSm),
                    Row(
                      children: [
                        Text(
                          '${_empresasFiltradas.length} empresa${_empresasFiltradas.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        if (filtrosActivos > 0) ...[
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sectorFiltro = null;
                                _ciudadFiltro = null;
                              });
                              _aplicarFiltros();
                            },
                            child: Text(
                              'Limpiar filtros',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spacingSm),
            const Divider(height: 1),

            // Empresas
            Expanded(child: _buildLista()),
          ],
        ),
      ),
    );
  }

  Widget _buildLista() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No se pudieron cargar las empresas',
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
      );
    }

    if (_empresasVisibles.isEmpty) {
      return RefreshIndicator(
        onRefresh: _cargarDatos,
        child: ListView(
          children: const [
            SizedBox(height: 80),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off, size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No hay empresas para esta búsqueda',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: ListView.builder(
        controller: _scrollCtrl,
        padding: const EdgeInsets.fromLTRB(
          AppDimens.spacingMd,
          AppDimens.spacingMd,
          AppDimens.spacingMd,
          AppDimens.spacingMd,
        ),
        itemCount: _empresasVisibles.length + (_hayMas ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _empresasVisibles.length) {
            // Cargando
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final empresa = _empresasVisibles[index];
          return EmpresaCard(
            empresa: empresa,
            ciudadNombre: _ciudadesById[empresa.idCiudad]?.nombre,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmpresaDetailScreen(empresa: empresa),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FiltrosSheet extends StatefulWidget {
  final List<String> sectores;
  final List<Ciudad> ciudades;
  final String? sectorSeleccionado;
  final int? ciudadSeleccionada;
  final void Function(String? sector, int? ciudad) onApply;

  const _FiltrosSheet({
    required this.sectores,
    required this.ciudades,
    required this.sectorSeleccionado,
    required this.ciudadSeleccionada,
    required this.onApply,
  });

  @override
  State<_FiltrosSheet> createState() => _FiltrosSheetState();
}

class _FiltrosSheetState extends State<_FiltrosSheet> {
  String? _sector;
  int? _ciudad;

  @override
  void initState() {
    super.initState();
    _sector = widget.sectorSeleccionado;
    _ciudad = widget.ciudadSeleccionada;
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacingMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _sector = null;
                    _ciudad = null;
                  }),
                  child: const Text('Limpiar todo'),
                ),
              ],
            ),
          ),

          const Divider(),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spacingMd,
                0,
                AppDimens.spacingMd,
                AppDimens.spacingMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sector
                  if (widget.sectores.isNotEmpty) ...[
                    Text(
                      'Sector',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: widget.sectores.map((s) {
                        return FilterChip(
                          label: Text(s),
                          selected: _sector == s,
                          onSelected: (_) =>
                              setState(() => _sector = _sector == s ? null : s),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimens.spacingLg),
                  ],

                  // Ciudad
                  if (widget.ciudades.isNotEmpty) ...[
                    Text(
                      'Ciudad',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _ciudad,
                      hint: const Text('Todas las ciudades'),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city_outlined),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas las ciudades'),
                        ),
                        ...widget.ciudades.map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nombre),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _ciudad = v),
                    ),
                    const SizedBox(height: AppDimens.spacingLg),
                  ],
                ],
              ),
            ),
          ),

          // Aplicar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spacingMd,
              0,
              AppDimens.spacingMd,
              AppDimens.spacingLg,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(_sector, _ciudad);
              },
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
