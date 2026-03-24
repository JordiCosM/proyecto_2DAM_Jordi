import DropdownEstado from './DropdownEstado'

function TablaReservas({ reservas, onCambiarEstado, onEliminar }) {
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
                            <th>Estado</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {reservas.map((reserva) => (
                            <tr key={reserva.id}>
                                <td>{reserva.fecha}</td>
                                <td>{reserva.horaInicio?.slice(0, 5)} – {reserva.horaFin?.slice(0, 5)}</td>
                                <td>{reserva.nombreServicio}</td>
                                <td>
                                    <span className="text-muted">
                                        <i className="bi bi-person me-1" />
                                        {reserva.nombreUsuario || `#${reserva.idUsuario}`}
                                    </span>
                                </td>
                                <td>
                                    <DropdownEstado reserva={reserva} onCambiarEstado={onCambiarEstado} />
                                </td>
                                <td className="text-end">
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