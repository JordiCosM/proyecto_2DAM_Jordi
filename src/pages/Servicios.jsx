import { useState, useEffect } from 'react'
import { useAuth } from '../context/AuthContext'
import { getEmpresasByUsuario } from '../services/empresaService'
import { getServiciosByEmpresa, createServicio, updateServicio, deleteServicio } from '../services/servicioService'
import useFetch from '../hooks/useFetch'
import useToast from '../hooks/useToast'
import ServicioFormModal from '../components/servicios/ServicioFormModal'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import '../styles/servicios.css'
import '../styles/common.css'

function Servicios() {
    const { usuario } = useAuth()
    const { data: empresas, loading: loadingEmpresas } = useFetch(
        () => getEmpresasByUsuario(usuario.id), [usuario.id]
    )
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const { data: servicios, loading: loadingServicios, refetch } = useFetch(
        () => empresaActiva ? getServiciosByEmpresa(empresaActiva.id) : Promise.resolve([]),
        [empresaActiva?.id]
    )
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [modalForm, setModalForm] = useState(false)
    const [servicioEditando, setServicioEditando] = useState(null)
    const [servicioBorrando, setServicioBorrando] = useState(null)
    const [loadingDelete, setLoadingDelete] = useState(false)

    useEffect(() => {
        if (empresas?.length === 1 && !empresaActiva) setEmpresaActiva(empresas[0])
    }, [empresas])

    const handleGuardar = async (form) => {
        try {
            if (servicioEditando) {
                await updateServicio(servicioEditando.id, form)
            } else {
                await createServicio(form)
            }
            setModalForm(false)
            setServicioEditando(null)
            mostrarExito('Servicio guardado correctamente')
            refetch()
        } catch {
            mostrarError('Error al guardar el servicio.')
        }
    }

    const handleEliminar = async () => {
        setLoadingDelete(true)
        try {
            await deleteServicio(servicioBorrando.id)
            setServicioBorrando(null)
            mostrarExito('Servicio eliminado correctamente')
            refetch()
        } catch {
            mostrarError('Error al eliminar el servicio.')
        } finally {
            setLoadingDelete(false)
        }
    }

    const abrirEditar = (servicio) => { setServicioEditando(servicio); setModalForm(true) }
    const abrirNuevo = () => { setServicioEditando(null); setModalForm(true) }

    if (loadingEmpresas) {
        return <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
    }

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Servicios</h4>
                {empresaActiva && (
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Nuevo servicio
                    </button>
                )}
            </div>

            {empresas?.length > 1 && (
                <div className="mb-4">
                    <p className="text-muted small mb-2">Selecciona una empresa</p>
                    <div className="d-flex flex-wrap gap-2">
                        {empresas.map((e) => (
                            <button
                                key={e.id}
                                className={`empresa-selector-btn ${empresaActiva?.id === e.id ? 'selected' : ''}`}
                                onClick={() => setEmpresaActiva(e)}
                            >
                                <i className="bi bi-building me-2" />{e.nombre}
                            </button>
                        ))}
                    </div>
                </div>
            )}

            {!empresaActiva ? (
                <div className="empty-state">
                    <i className="bi bi-building" />
                    <p>Selecciona una empresa para ver sus servicios</p>
                </div>
            ) : loadingServicios ? (
                <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
            ) : !servicios?.length ? (
                <div className="empty-state">
                    <i className="bi bi-grid" />
                    <p>Esta empresa no tiene servicios todavía</p>
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Crear servicio
                    </button>
                </div>
            ) : (
                <div className="row g-3">
                    {servicios.map((servicio) => (
                        <div className="col-12 col-md-6 col-xl-4" key={servicio.id}>
                            <div className="card servicio-card h-100">
                                <div className="card-body">
                                    <div className="d-flex align-items-start justify-content-between mb-2">
                                        <h6 className="fw-semibold mb-0">{servicio.nombre}</h6>
                                        <span className="servicio-precio">{servicio.precio} €</span>
                                    </div>
                                    {servicio.descripcion && (
                                        <p className="text-muted small mb-3" style={{ lineHeight: 1.5 }}>{servicio.descripcion}</p>
                                    )}
                                    <div className="mb-3">
                                        <span className="servicio-duracion">
                                            <i className="bi bi-clock me-1" />{servicio.duracion} min
                                        </span>
                                    </div>
                                    <div className="d-flex gap-2">
                                        <button className="btn btn-outline-primary btn-sm flex-grow-1" onClick={() => abrirEditar(servicio)}>
                                            <i className="bi bi-pencil me-1" />Editar
                                        </button>
                                        <button className="btn btn-outline-danger btn-sm" onClick={() => setServicioBorrando(servicio)}>
                                            <i className="bi bi-trash" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {modalForm && (
                <ServicioFormModal
                    servicio={servicioEditando}
                    empresas={empresas || []}
                    onGuardar={handleGuardar}
                    onCerrar={() => { setModalForm(false); setServicioEditando(null) }}
                />
            )}

            {servicioBorrando && (
                <ConfirmModal
                    mensaje={`¿Seguro que quieres eliminar "${servicioBorrando.nombre}"?`}
                    onConfirmar={handleEliminar}
                    onCerrar={() => setServicioBorrando(null)}
                    loading={loadingDelete}
                />
            )}

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Servicios