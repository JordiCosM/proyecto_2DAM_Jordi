const ESTADOS = ['PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'FINALIZADA']

function FiltrosReservas({ servicios, filtros, onChange, onLimpiar }) {
    const hayFiltros = filtros.estado || filtros.fecha || filtros.servicio

    return (
        <div className="reservas-filtros">
            <div className="row g-2 align-items-end">
                <div className="col-12 col-sm-4">
                    <label className="form-label small mb-1">Estado</label>
                    <select
                        className="form-select form-select-sm"
                        value={filtros.estado}
                        onChange={(e) => onChange({ ...filtros, estado: e.target.value })}
                    >
                        <option value="">Todos</option>
                        {ESTADOS.map((e) => <option key={e} value={e}>{e}</option>)}
                    </select>
                </div>
                <div className="col-12 col-sm-4">
                    <label className="form-label small mb-1">Fecha</label>
                    <input
                        type="date"
                        className="form-control form-control-sm"
                        value={filtros.fecha}
                        onChange={(e) => onChange({ ...filtros, fecha: e.target.value })}
                    />
                </div>
                <div className="col-12 col-sm-4">
                    <label className="form-label small mb-1">Servicio</label>
                    <select
                        className="form-select form-select-sm"
                        value={filtros.servicio}
                        onChange={(e) => onChange({ ...filtros, servicio: e.target.value })}
                    >
                        <option value="">Todos</option>
                        {servicios.map((s) => <option key={s.id} value={s.id}>{s.nombre}</option>)}
                    </select>
                </div>
                {hayFiltros && (
                    <div className="col-12">
                        <button className="btn btn-link btn-sm p-0 text-muted" onClick={onLimpiar}>
                            <i className="bi bi-x-circle me-1" />Limpiar filtros
                        </button>
                    </div>
                )}
            </div>
        </div>
    )
}

export default FiltrosReservas