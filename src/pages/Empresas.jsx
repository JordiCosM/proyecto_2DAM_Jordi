import { useState } from 'react'
import { useAuth } from '../context/AuthContext'
import { getEmpresasByUsuario, createEmpresa, updateEmpresa, deleteEmpresa } from '../services/empresaService'
import useFetch from '../hooks/useFetch'
import useToast from '../hooks/useToast'
import EmpresaFormModal from '../components/empresas/EmpresaFormModal'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import '../styles/empresas.css'

function Empresas() {
    const { usuario } = useAuth()
    const { data: empresas, loading, error, refetch } = useFetch(
        () => getEmpresasByUsuario(usuario.id), [usuario.id]
    )
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [modalForm, setModalForm] = useState(false)
    const [empresaEditando, setEmpresaEditando] = useState(null)
    const [empresaBorrando, setEmpresaBorrando] = useState(null)
    const [loadingDelete, setLoadingDelete] = useState(false)

    const handleGuardar = async (form) => {
        try {
            if (empresaEditando) {
                await updateEmpresa(empresaEditando.id, { ...form, idUsuario: usuario.id })
            } else {
                await createEmpresa({ ...form, idUsuario: usuario.id })
            }
            setModalForm(false)
            setEmpresaEditando(null)
            mostrarExito('Empresa guardada correctamente')
            refetch()
        } catch {
            mostrarError('Error al guardar la empresa.')
        }
    }

    const handleEliminar = async () => {
        setLoadingDelete(true)
        try {
            await deleteEmpresa(empresaBorrando.id)
            setEmpresaBorrando(null)
            mostrarExito('Empresa eliminada correctamente')
            refetch()
        } catch {
            mostrarError('Error al eliminar la empresa.')
        } finally {
            setLoadingDelete(false)
        }
    }

    const abrirEditar = (empresa) => { setEmpresaEditando(empresa); setModalForm(true) }
    const abrirNueva = () => { setEmpresaEditando(null); setModalForm(true) }

    if (loading) {
        return (
            <div className="spinner-fullpage">
                <div className="spinner-border text-primary" />
            </div>
        )
    }

    if (error) return <div className="alert alert-danger">{error}</div>

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Mis empresas</h4>
                <button className="btn btn-primary btn-sm" onClick={abrirNueva}>
                    <i className="bi bi-plus-lg me-1" />Nueva empresa
                </button>
            </div>

            {!empresas?.length ? (
                <div className="empty-state">
                    <i className="bi bi-building" />
                    <p>No tienes empresas todavía</p>
                    <button className="btn btn-primary btn-sm" onClick={abrirNueva}>
                        <i className="bi bi-plus-lg me-1" />Crear empresa
                    </button>
                </div>
            ) : (
                <div className="row g-3">
                    {empresas.map((empresa) => (
                        <div className="col-12 col-md-6 col-xl-4" key={empresa.id}>
                            <div className="card empresa-card h-100">
                                <div className="card-body">
                                    <div className="d-flex align-items-start gap-3 mb-3">
                                        {empresa.logoUrl
                                            ? <img src={empresa.logoUrl} alt={empresa.nombre} className="empresa-logo" />
                                            : <div className="empresa-logo-placeholder"><i className="bi bi-building" /></div>
                                        }
                                        <div className="flex-grow-1">
                                            <h6 className="fw-semibold mb-1">{empresa.nombre}</h6>
                                            {empresa.sector && <span className="empresa-sector-badge">{empresa.sector}</span>}
                                        </div>
                                    </div>

                                    {empresa.descripcion && (
                                        <p className="text-muted small mb-3" style={{ lineHeight: 1.5 }}>{empresa.descripcion}</p>
                                    )}

                                    <div className="d-flex flex-column gap-1 mb-3">
                                        {empresa.direccion && <span className="small text-muted"><i className="bi bi-geo-alt me-1" />{empresa.direccion}</span>}
                                        {empresa.telefono && <span className="small text-muted"><i className="bi bi-telephone me-1" />{empresa.telefono}</span>}
                                        {empresa.email && <span className="small text-muted"><i className="bi bi-envelope me-1" />{empresa.email}</span>}
                                    </div>

                                    <div className="d-flex gap-2">
                                        <button className="btn btn-outline-primary btn-sm flex-grow-1" onClick={() => abrirEditar(empresa)}>
                                            <i className="bi bi-pencil me-1" />Editar
                                        </button>
                                        <button className="btn btn-outline-danger btn-sm" onClick={() => setEmpresaBorrando(empresa)}>
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
                <EmpresaFormModal
                    empresa={empresaEditando}
                    onGuardar={handleGuardar}
                    onCerrar={() => { setModalForm(false); setEmpresaEditando(null) }}
                />
            )}

            {empresaBorrando && (
                <ConfirmModal
                    mensaje={`¿Seguro que quieres eliminar "${empresaBorrando.nombre}"? Esta acción no se puede deshacer.`}
                    onConfirmar={handleEliminar}
                    onCerrar={() => setEmpresaBorrando(null)}
                    loading={loadingDelete}
                />
            )}

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Empresas