import '../../styles/home.css'
import { IMG_BASE_URL } from '../../services/api'

function EmpresaReservas({ empresa, servicios, reservasPorServicio }) {
    const reservasDelDia = (idServicio) => reservasPorServicio[idServicio] || []
    const hayReservas = servicios.some((s) => reservasDelDia(s.id).length > 0)
    const imgUrl = (ruta) => ruta ? `${IMG_BASE_URL}${ruta}` : null

    return (
        <div className="card reservas-card mb-4">
            <div className="card-header d-flex align-items-center justify-content-between">
                <div className="d-flex align-items-center gap-2">
                    {empresa.logoUrl
                        ? <img src={imgUrl(empresa.logoUrl)} alt={empresa.nombre} style={{ width: 36, height: 36, borderRadius: 8, objectFit: 'cover' }} />
                        : <div className="d-flex align-items-center justify-content-center bg-primary bg-opacity-10 rounded"
                            style={{ width: 36, height: 36 }}>
                            <i className="bi bi-building text-primary" />
                        </div>
                    }
                    <div>
                        <div className="fw-semibold">{empresa.nombre}</div>
                        <div className="text-muted" style={{ fontSize: '0.78rem' }}>{empresa.sector}</div>
                    </div>
                </div>
            </div>

            <div className="card-body p-3">
                {servicios.length === 0 ? (
                    <div className="sin-reservas">
                        <i className="bi bi-grid d-block mb-1" style={{ fontSize: '1.5rem' }} />
                        Esta empresa no tiene servicios aún
                    </div>
                ) : !hayReservas ? (
                    <div className="sin-reservas">
                        <i className="bi bi-calendar-x d-block mb-1" style={{ fontSize: '1.5rem' }} />
                        No hay reservas para este día
                    </div>
                ) : (
                    <div className="d-flex flex-column gap-2">
                        {servicios.map((servicio) => {
                            const reservas = reservasDelDia(servicio.id)
                            if (!reservas.length) return null

                            return (
                                <div key={servicio.id} className="servicio-bloque">
                                    <div className="servicio-bloque-header">
                                        <i className="bi bi-scissors" />
                                        {servicio.nombre}
                                        <span className="ms-auto text-muted fw-normal">
                                            {reservas.length} reserva{reservas.length !== 1 ? 's' : ''}
                                        </span>
                                    </div>

                                    {reservas
                                        .sort((a, b) => a.horaInicio.localeCompare(b.horaInicio))
                                        .map((reserva) => (
                                            <div key={reserva.id} className="reserva-item">
                                                <span className="reserva-hora">
                                                    <i className="bi bi-clock me-1 text-muted" style={{ fontSize: '0.75rem' }} />
                                                    {reserva.horaInicio.slice(0, 5)} – {reserva.horaFin.slice(0, 5)}
                                                </span>

                                                <span className="reserva-info">
                                                    <i className="bi bi-person me-1 text-muted" style={{ fontSize: '0.75rem' }} />
                                                    <span className="cliente-nombre">{reserva.nombreCliente}</span>
                                                    {reserva.telefonoCliente && (
                                                        <span className="cliente-telefono">
                                                            <i className="bi bi-telephone me-1" />{reserva.telefonoCliente}
                                                        </span>
                                                    )}
                                                </span>

                                                {reserva.nombresEmpleados?.length > 0 ? (
                                                    <div className="reserva-empleados">
                                                        {reserva.nombresEmpleados.map((nombre, i) => (
                                                            <span key={i} className="reserva-empleado-tag">
                                                                <i className="bi bi-person-badge" style={{ fontSize: '0.7rem' }} />
                                                                {nombre}
                                                            </span>
                                                        ))}
                                                    </div>
                                                ) : <div />}

                                                <span className={`estado-badge estado-${reserva.estado}`}>
                                                    {reserva.estado}
                                                </span>
                                            </div>
                                        ))}
                                </div>
                            )
                        })}
                    </div>
                )}
            </div>
        </div>
    )
}

export default EmpresaReservas