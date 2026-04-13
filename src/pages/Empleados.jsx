import { useState, useEffect } from 'react'
import useAuth from '../hooks/useAuth'
import useEmpresas from '../hooks/useEmpresas'
import { getEmpleadosByEmpresa, createEmpleado, updateEmpleado, activarEmpleado, desactivarEmpleado } from '../services/empleadoService'
import useFetch from '../hooks/useFetch'
import useToast from '../hooks/useToast'
import { puedeEditar } from '../utils/permisos'
import EmpleadoFormModal from '../components/empleados/EmpleadoFormModal'
import ConfirmModal from '../components/common/ConfirmModal'
import EmpresaSelector from '../components/common/EmpresaSelector'
import SpinnerPage from '../components/common/SpinnerPage'
import EmptyState from '../components/common/EmptyState'
import Toast from '../components/common/Toast'
import '../styles/empleados.css'
import '../styles/common.css'

function Empleados() {
    const { usuario } = useAuth()
    const canEdit = puedeEditar(usuario)

    const { data: empresas, loading: loadingEmpresas } = useEmpresas()
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const [empleados, setEmpleados] = useState([])
    const [loadingEmpleados, setLoadingEmpleados] = useState(false)
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [modalForm, setModalForm] = useState(false)
    const [empleadoEditando, setEmpleadoEditando] = useState(null)
    const [confirmModal, setConfirmModal] = useState({ show: false, mensaje: '', onConfirmar: null })
    const [loadingAccion, setLoadingAccion] = useState(false)

    useEffect(() => {
        if (empresas?.length && !empresaActiva) setEmpresaActiva(empresas[0])
    }, [empresas])

    useEffect(() => {
        if (!empresaActiva?.id) return
        cargarEmpleados()
    }, [empresaActiva?.id])

    const cargarEmpleados = async () => {
        setLoadingEmpleados(true)
        try {
            const datos = await getEmpleadosByEmpresa(empresaActiva.id)
            setEmpleados(datos || [])
        } catch {
            mostrarError('Error al cargar los empleados.')
        } finally {
            setLoadingEmpleados(false)
        }
    }

    const handleGuardar = async (form) => {
        try {
            if (empleadoEditando) {
                await updateEmpleado(empleadoEditando.id, form)
                mostrarExito('Empleado actualizado correctamente')
            } else {
                await createEmpleado(form)
                mostrarExito('Empleado creado correctamente')
            }
            setModalForm(false)
            setEmpleadoEditando(null)
            cargarEmpleados()
        } catch {
            throw new Error('Error al guardar')
        }
    }

    const confirmarAccion = (mensaje, accion) => {
        setConfirmModal({ show: true, mensaje, onConfirmar: accion })
    }

    const handleToggleActivo = (empleado) => {
        const accion = empleado.activo ? 'desactivar' : 'activar'
        confirmarAccion(
            `¿Seguro que quieres ${accion} a ${empleado.nombre} ${empleado.apellidos}?`,
            async () => {
                setLoadingAccion(true)
                try {
                    empleado.activo
                        ? await desactivarEmpleado(empleado.id)
                        : await activarEmpleado(empleado.id)
                    mostrarExito(`Empleado ${accion === 'activar' ? 'activado' : 'desactivado'} correctamente`)
                    setConfirmModal({ show: false })
                    cargarEmpleados()
                } catch {
                    mostrarError(`Error al ${accion} el empleado.`)
                } finally {
                    setLoadingAccion(false)
                }
            }
        )
    }

    const abrirEditar = (empleado) => { setEmpleadoEditando(empleado); setModalForm(true) }
    const abrirNuevo = () => { setEmpleadoEditando(null); setModalForm(true) }

    if (loadingEmpresas) return <SpinnerPage />

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Empleados</h4>
                {canEdit && empresaActiva && (
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Nuevo empleado
                    </button>
                )}
            </div>

            <EmpresaSelector
                empresas={empresas}
                empresaActiva={empresaActiva}
                onSeleccionar={setEmpresaActiva}
            />

            {!empresaActiva ? (
                <EmptyState icono="bi-building" texto="Selecciona una empresa para ver sus empleados" />
            ) : loadingEmpleados ? (
                <SpinnerPage />
            ) : !empleados.length ? (
                <EmptyState icono="bi-people" texto="Esta empresa no tiene empleados todavía">
                    {canEdit && (
                        <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                            <i className="bi bi-plus-lg me-1" />Añadir empleado
                        </button>
                    )}
                </EmptyState>
            ) : (
                <div className="row g-3">
                    {empleados.map((empleado) => (
                        <div className="col-12 col-md-6 col-xl-4" key={empleado.id}>
                            <div className={`card empleado-card h-100 ${!empleado.activo ? 'empleado-inactivo' : ''}`}>
                                <div className="card-body">
                                    <div className="d-flex align-items-start gap-3 mb-3">
                                        <div className="empleado-avatar">
                                            <i className="bi bi-person-fill" />
                                        </div>
                                        <div className="flex-grow-1">
                                            <h6 className="fw-semibold mb-1">
                                                {empleado.nombre} {empleado.apellidos}
                                                {!empleado.activo && (
                                                    <span className="ms-2 text-muted" style={{ fontSize: '0.72rem' }}>Inactivo</span>
                                                )}
                                            </h6>
                                            <span className={`rol-badge rol-${empleado.rol}`}>
                                                {empleado.rol.replace('_', ' ')}
                                            </span>
                                        </div>
                                    </div>

                                    <div className="d-flex flex-column gap-1 mb-3">
                                        {empleado.email && (
                                            <span className="small text-muted">
                                                <i className="bi bi-envelope me-1" />{empleado.email}
                                            </span>
                                        )}
                                        {empleado.telefono && (
                                            <span className="small text-muted">
                                                <i className="bi bi-telephone me-1" />{empleado.telefono}
                                            </span>
                                        )}
                                    </div>

                                    {canEdit && (
                                        <div className="d-flex gap-2">
                                            <button className="btn btn-outline-primary btn-sm flex-grow-1" onClick={() => abrirEditar(empleado)}>
                                                <i className="bi bi-pencil me-1" />Editar
                                            </button>
                                            <button
                                                className={`btn btn-sm ${empleado.activo ? 'btn-outline-warning' : 'btn-outline-success'}`}
                                                onClick={() => handleToggleActivo(empleado)}
                                                title={empleado.activo ? 'Desactivar' : 'Activar'}
                                            >
                                                <i className={`bi ${empleado.activo ? 'bi-person-dash' : 'bi-person-check'}`} />
                                            </button>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            <EmpleadoFormModal
                show={modalForm}
                empleado={empleadoEditando}
                idEmpresa={empresaActiva?.id}
                onGuardar={handleGuardar}
                onCerrar={() => { setModalForm(false); setEmpleadoEditando(null) }}
            />

            <ConfirmModal
                show={confirmModal.show}
                mensaje={confirmModal.mensaje}
                onConfirmar={confirmModal.onConfirmar}
                onCerrar={() => setConfirmModal({ show: false })}
                loading={loadingAccion}
            />

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Empleados