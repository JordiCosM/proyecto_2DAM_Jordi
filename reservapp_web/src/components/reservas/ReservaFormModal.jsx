import { useState, useEffect, useRef } from 'react'
import { getUsuarioPorEmail, crearCliente } from '../../services/usuarioService'
import { getServiciosByEmpresa } from '../../services/servicioService'
import { getEmpleadosActivosByEmpresa } from '../../services/empleadoService'
import { createReserva, asignarEmpleados } from '../../services/reservaService'
import useDisponibilidad from '../../hooks/useDisponibilidad'
import CalendarioDisponibilidad from './CalendarioDisponibilidad'
import SlotsDisponibles from './SlotsDisponibles'
import '../../styles/reservas.css'
import '../../styles/empleados.css'
import '../../styles/calendario.css'

function ReservaFormModal({ show, idEmpresa, onGuardar, onCerrar }) {
    const modalRef = useRef(null)
    const bsModal = useRef(null)

    const [servicios, setServicios] = useState([])
    const [empleados, setEmpleados] = useState([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    // Cliente
    const [emailBusqueda, setEmailBusqueda] = useState('')
    const [clienteEncontrado, setClienteEncontrado] = useState(null)
    const [buscandoCliente, setBuscandoCliente] = useState(false)
    const [formCliente, setFormCliente] = useState({ nombre: '', apellidos: '', telefono: '' })

    // Reserva
    const [servicioSeleccionado, setServicioSeleccionado] = useState(null)
    const [fecha, setFecha] = useState('')
    const [slotSeleccionado, setSlotSeleccionado] = useState('')
    const [horaFin, setHoraFin] = useState('')
    const [empleadosSeleccionados, setEmpleadosSeleccionados] = useState([])

    const { loading: loadingDisp, getSlotsForDate, getEstadoDia } = useDisponibilidad(
        idEmpresa, servicioSeleccionado
    )

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
        getServiciosByEmpresa(idEmpresa).then(setServicios).catch(() => { })
        getEmpleadosActivosByEmpresa(idEmpresa).then(setEmpleados).catch(() => { })
        resetForm()
    }, [show, idEmpresa])

    const resetForm = () => {
        setEmailBusqueda(''); setClienteEncontrado(null)
        setFormCliente({ nombre: '', apellidos: '', telefono: '' })
        setServicioSeleccionado(null); setFecha('')
        setSlotSeleccionado(''); setHoraFin('')
        setEmpleadosSeleccionados([]); setError(null)
    }

    const handleSelectSlot = (hora) => {
        setSlotSeleccionado(hora)
        if (!servicioSeleccionado) return
        const [h, m] = hora.split(':').map(Number)
        const total = h * 60 + m + servicioSeleccionado.duracion
        const hFin = String(Math.floor(total / 60)).padStart(2, '0')
        const mFin = String(total % 60).padStart(2, '0')
        setHoraFin(`${hFin}:${mFin}`)
    }

    const handleSelectFecha = (f) => {
        setFecha(f)
        setSlotSeleccionado('')
        setHoraFin('')
    }

    const handleServicio = (e) => {
        const s = servicios.find((sv) => String(sv.id) === e.target.value) || null
        setServicioSeleccionado(s)
        setFecha(''); setSlotSeleccionado(''); setHoraFin('')
    }

    const buscarCliente = async () => {
        if (!emailBusqueda) return
        setBuscandoCliente(true)
        try {
            const usuario = await getUsuarioPorEmail(emailBusqueda)
            setClienteEncontrado(usuario)
        } catch {
            setClienteEncontrado(false)
        } finally {
            setBuscandoCliente(false)
        }
    }

    const toggleEmpleado = (id) => {
        setEmpleadosSeleccionados((prev) =>
            prev.includes(id) ? prev.filter((e) => e !== id) : [...prev, id]
        )
    }

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (!servicioSeleccionado || !fecha || !slotSeleccionado) {
            setError('Selecciona servicio, día y hora.')
            return
        }
        if (clienteEncontrado === null) {
            setError('Busca el cliente por email primero.')
            return
        }
        setLoading(true); setError(null)
        try {
            let idUsuario
            if (clienteEncontrado) {
                idUsuario = clienteEncontrado.id
            } else {
                const nuevo = await crearCliente({
                    nombre: formCliente.nombre, apellidos: formCliente.apellidos,
                    email: emailBusqueda, telefono: formCliente.telefono,
                })
                idUsuario = nuevo.id
            }

            const reserva = await createReserva({
                idUsuario,
                idServicio: servicioSeleccionado.id,
                fecha,
                horaInicio: `${slotSeleccionado}:00`,
                horaFin: `${horaFin}:00`,
                estado: 'PENDIENTE',
                idEmpleados: empleadosSeleccionados,
            })

            if (empleadosSeleccionados.length > 0) {
                await asignarEmpleados(reserva.id, empleadosSeleccionados)
            }

            await onGuardar(reserva)
        } catch {
            setError('Error al crear la reserva.')
        } finally {
            setLoading(false)
        }
    }

    const slotsDelDia = fecha && servicioSeleccionado ? getSlotsForDate(fecha) : []

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered modal-lg">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">Nueva reserva</h5>
                        <button className="btn-close" onClick={onCerrar} disabled={loading} />
                    </div>

                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}

                        <form id="reserva-form" onSubmit={handleSubmit}>
                            <div className="row g-4">

                                {/* Cliente */}
                                <div className="col-12">
                                    <label className="form-label fw-semibold small text-uppercase text-muted" style={{ letterSpacing: '0.05em' }}>
                                        Cliente
                                    </label>
                                    <div className="d-flex gap-2">
                                        <input
                                            type="email"
                                            className="form-control"
                                            placeholder="Email del cliente"
                                            value={emailBusqueda}
                                            onChange={(e) => { setEmailBusqueda(e.target.value); setClienteEncontrado(null) }}
                                        />
                                        <button
                                            type="button"
                                            className="btn btn-outline-primary"
                                            onClick={buscarCliente}
                                            disabled={!emailBusqueda || buscandoCliente}
                                            style={{ whiteSpace: 'nowrap' }}
                                        >
                                            {buscandoCliente
                                                ? <span className="spinner-border spinner-border-sm" />
                                                : <><i className="bi bi-search me-1" />Buscar</>}
                                        </button>
                                    </div>

                                    {clienteEncontrado && (
                                        <div className="cliente-encontrado mt-2">
                                            <i className="bi bi-person-check-fill" />
                                            <span>
                                                <strong>{clienteEncontrado.nombre} {clienteEncontrado.apellidos}</strong>
                                                {clienteEncontrado.telefono && (
                                                    <span className="ms-2 opacity-75">
                                                        <i className="bi bi-telephone me-1" />{clienteEncontrado.telefono}
                                                    </span>
                                                )}
                                            </span>
                                        </div>
                                    )}

                                    {clienteEncontrado === false && (
                                        <div className="mt-2">
                                            <div className="cliente-nuevo mb-2">
                                                <i className="bi bi-person-plus-fill" />
                                                <span>Email no registrado — se creará un nuevo cliente</span>
                                            </div>
                                            <div className="row g-2">
                                                <div className="col-md-4">
                                                    <input className="form-control form-control-sm" placeholder="Nombre" value={formCliente.nombre}
                                                        onChange={(e) => setFormCliente({ ...formCliente, nombre: e.target.value })} required />
                                                </div>
                                                <div className="col-md-4">
                                                    <input className="form-control form-control-sm" placeholder="Apellidos" value={formCliente.apellidos}
                                                        onChange={(e) => setFormCliente({ ...formCliente, apellidos: e.target.value })} required />
                                                </div>
                                                <div className="col-md-4">
                                                    <input className="form-control form-control-sm" placeholder="Teléfono (opcional)" value={formCliente.telefono}
                                                        onChange={(e) => setFormCliente({ ...formCliente, telefono: e.target.value })} />
                                                </div>
                                            </div>
                                        </div>
                                    )}
                                </div>

                                {/* Servicio */}
                                <div className="col-12">
                                    <label className="form-label fw-semibold small text-uppercase text-muted" style={{ letterSpacing: '0.05em' }}>
                                        Servicio
                                    </label>
                                    <select className="form-select" value={servicioSeleccionado?.id || ''} onChange={handleServicio} required>
                                        <option value="">Selecciona un servicio</option>
                                        {servicios.map((s) => (
                                            <option key={s.id} value={s.id}>
                                                {s.nombre} — {s.duracion} min — {s.precio} € — Cap. {s.capacidad ?? 1}
                                            </option>
                                        ))}
                                    </select>
                                </div>

                                {/* Calendario y Slots */}
                                {servicioSeleccionado && (
                                    <div className="col-12">
                                        <label className="form-label fw-semibold small text-uppercase text-muted" style={{ letterSpacing: '0.05em' }}>
                                            Fecha y hora
                                        </label>
                                        {loadingDisp ? (
                                            <div className="text-center py-3">
                                                <span className="spinner-border spinner-border-sm text-primary" />
                                            </div>
                                        ) : (
                                            <div className="d-flex gap-4 flex-wrap align-items-start">
                                                <CalendarioDisponibilidad
                                                    getEstadoDia={getEstadoDia}
                                                    fechaSeleccionada={fecha}
                                                    onSelectFecha={handleSelectFecha}
                                                />

                                                {fecha && (
                                                    <div className="flex-grow-1">
                                                        <p className="text-muted small mb-2">
                                                            {new Date(fecha + 'T00:00:00').toLocaleDateString('es-ES', { weekday: 'long', day: 'numeric', month: 'long' })}
                                                        </p>
                                                        <SlotsDisponibles
                                                            slots={slotsDelDia}
                                                            slotSeleccionado={slotSeleccionado}
                                                            onSelectSlot={handleSelectSlot}
                                                        />
                                                        {slotSeleccionado && (
                                                            <div className="mt-2 small text-muted">
                                                                <i className="bi bi-clock me-1" />
                                                                Reserva de <strong>{slotSeleccionado}</strong> a <strong>{horaFin}</strong>
                                                            </div>
                                                        )}
                                                    </div>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                )}

                                {/* Empleados */}
                                {empleados.length > 0 && (
                                    <div className="col-12">
                                        <label className="form-label fw-semibold small text-uppercase text-muted" style={{ letterSpacing: '0.05em' }}>
                                            Empleados <span className="fw-normal normal-case" style={{ textTransform: 'none', letterSpacing: 0 }}>(opcional)</span>
                                        </label>
                                        <div className="border rounded p-2" style={{ maxHeight: 160, overflowY: 'auto' }}>
                                            {empleados.map((emp) => (
                                                <div key={emp.id} className="empleado-check-item" onClick={() => toggleEmpleado(emp.id)}>
                                                    <input
                                                        type="checkbox"
                                                        checked={empleadosSeleccionados.includes(emp.id)}
                                                        onChange={() => toggleEmpleado(emp.id)}
                                                        onClick={(e) => e.stopPropagation()}
                                                    />
                                                    <span>{emp.nombre} {emp.apellidos}</span>
                                                    <span className={`ms-auto rol-badge rol-${emp.rol}`} style={{ fontSize: '0.7rem' }}>
                                                        {emp.rol.replace('_', ' ')}
                                                    </span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                )}

                            </div>
                        </form>
                    </div>

                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={onCerrar} disabled={loading}>Cancelar</button>
                        <button
                            className="btn btn-primary"
                            type="submit"
                            form="reserva-form"
                            disabled={loading || !slotSeleccionado}
                        >
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Creando...</>
                                : <><i className="bi bi-check-lg me-2" />Crear reserva</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default ReservaFormModal