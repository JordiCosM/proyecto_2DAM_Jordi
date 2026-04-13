import DropdownEstado from './DropdownEstado'

function TablaReservas({ reservas, onCambiarEstado, onEliminar, onEditarEmpleados }) {
    if (!reservas.length) {
        return (
            <div className="text-center py-5 text-muted">
                <i className="bi bi-calendar-x d-block mb-2" style={{ fontSize: '2rem' }} />
                <p>No hay reservas con los filtros seleccionados</p>
            </div>
        )
    }

    return (
        <div className="card reservas-tabla-card">
            <div className="table-responsive">
                <table className="table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Servicio</th>
                            <th>Cliente</th>
                            <th>Empleados</th>
                            <th>Estado</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {reservas.map((reserva) => (
                            <tr key={reserva.id}>
                                <td>{reserva.fecha}</td>
                                <td style={{ whiteSpace: 'nowrap' }}>
                                    {reserva.horaInicio?.slice(0, 5)} – {reserva.horaFin?.slice(0, 5)}
                                </td>
                                <td>{reserva.nombreServicio}</td>
                                <td>
                                    <span className="small text-muted cliente-nombre">
                                        <i className="bi bi-person me-1" />{reserva.nombreCliente}
                                    </span>
                                    {reserva.telefonoCliente && (
                                        <span className="cliente-telefono">
                                            <i className="bi bi-telephone me-1" />{reserva.telefonoCliente}
                                        </span>
                                    )}
                                </td>
                                <td>
                                    {reserva.nombresEmpleados?.length ? (
                                        <div className="d-flex flex-column gap-1">
                                            {reserva.nombresEmpleados.map((nombre, i) => (
                                                <span key={i} className="small text-muted">
                                                    <i className="bi bi-person-badge" />{nombre}
                                                </span>
                                            ))}
                                        </div>
                                    ) : (
                                        <span className="small text-muted">—</span>
                                    )}
                                </td>
                                <td>
                                    <DropdownEstado reserva={reserva} onCambiarEstado={onCambiarEstado} />
                                </td>
                                <td className="text-end" style={{ whiteSpace: 'nowrap' }}>
                                    <button
                                        className="btn btn-outline-secondary btn-sm me-1"
                                        onClick={() => onEditarEmpleados?.(reserva)}
                                        title="Asignar empleados"
                                    >
                                        <i className="bi bi-people" />
                                    </button>
                                    <button
                                        className="btn btn-outline-danger btn-sm"
                                        onClick={() => onEliminar(reserva)}
                                    >
                                        <i className="bi bi-trash" />
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    )
}

export default TablaReservas