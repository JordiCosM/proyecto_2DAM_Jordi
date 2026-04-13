import { useState, useEffect, useRef } from 'react'
import { getEmpleadosActivosByEmpresa } from '../../services/empleadoService'
import { asignarEmpleados, desasignarEmpleado } from '../../services/reservaService'
import '../../styles/empleados.css'

function ReservaEditModal({ show, reserva, idEmpresa, onGuardar, onCerrar }) {
    const modalRef = useRef(null)
    const bsModal = useRef(null)
    const [empleados, setEmpleados] = useState([])
    const [seleccionados, setSeleccionados] = useState([])
    const [seleccionadosOriginal, setSeleccionadosOriginal] = useState([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    useEffect(() => {
        if (!modalRef.current || !window.bootstrap) return
        bsModal.current = new window.bootstrap.Modal(modalRef.current, { backdrop: 'static' })
        return () => { bsModal.current?.dispose(); bsModal.current = null }
    }, [])

    useEffect(() => {
        if (!bsModal.current) return
        show ? bsModal.current.show() : bsModal.current.hide()
    }, [show])

    useEffect(() => {
        if (!show || !idEmpresa) return
        getEmpleadosActivosByEmpresa(idEmpresa).then(setEmpleados).catch(() => { })
        const ids = reserva?.idEmpleados || []
        setSeleccionados(ids)
        setSeleccionadosOriginal(ids)
        setError(null)
    }, [show, idEmpresa, reserva])

    const toggle = (id) => {
        setSeleccionados((prev) =>
            prev.includes(id) ? prev.filter((e) => e !== id) : [...prev, id]
        )
    }

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        try {
            const aDesasignar = seleccionadosOriginal.filter((id) => !seleccionados.includes(id))
            for (const id of aDesasignar) {
                await desasignarEmpleado(reserva.id, id)
            }

            if (seleccionados.length > 0) {
                await asignarEmpleados(reserva.id, seleccionados)
            }

            await onGuardar()
        } catch {
            setError('Error al actualizar los empleados.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">Asignar empleados</h5>
                        <button className="btn-close" onClick={onCerrar} disabled={loading} />
                    </div>

                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}

                        {reserva && (
                            <div className="mb-3 p-3 bg-light rounded small">
                                <div><i className="bi bi-calendar3 me-1 text-muted" />{reserva.fecha}</div>
                                <div><i className="bi bi-clock me-1 text-muted" />{reserva.horaInicio?.slice(0, 5)} – {reserva.horaFin?.slice(0, 5)}</div>
                                <div><i className="bi bi-person me-1 text-muted" />{reserva.nombreCliente || `Cliente #${reserva.idUsuario}`}</div>
                            </div>
                        )}

                        <form id="reserva-edit-form" onSubmit={handleSubmit}>
                            <label className="form-label fw-semibold small text-uppercase text-muted" style={{ letterSpacing: '0.05em' }}>
                                Empleados asignados
                            </label>
                            {empleados.length === 0 ? (
                                <p className="text-muted small">No hay empleados activos en esta empresa.</p>
                            ) : (
                                <div className="border rounded p-2" style={{ maxHeight: 220, overflowY: 'auto' }}>
                                    {empleados.map((emp) => (
                                        <div key={emp.id} className="empleado-check-item" onClick={() => toggle(emp.id)}>
                                            <input
                                                type="checkbox"
                                                checked={seleccionados.includes(emp.id)}
                                                onChange={() => toggle(emp.id)}
                                                onClick={(e) => e.stopPropagation()}
                                            />
                                            <span>{emp.nombre} {emp.apellidos}</span>
                                            <span className={`ms-auto rol-badge rol-${emp.rol}`} style={{ fontSize: '0.7rem' }}>
                                                {emp.rol.replace('_', ' ')}
                                            </span>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </form>
                    </div>

                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={onCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-primary" type="submit" form="reserva-edit-form" disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Guardando...</>
                                : <><i className="bi bi-check-lg me-2" />Guardar</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default ReservaEditModal