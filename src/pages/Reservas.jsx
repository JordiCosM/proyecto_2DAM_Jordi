import { useState, useEffect } from 'react'
import { useAuth } from '../context/AuthContext'
import { getEmpresasByUsuario } from '../services/empresaService'
import { updateEstado, deleteReserva } from '../services/reservaService'
import useFetch from '../hooks/useFetch'
import useReservas from '../hooks/useReservas'
import useToast from '../hooks/useToast'
import FiltrosReservas from '../components/reservas/FiltrosReservas'
import TablaReservas from '../components/reservas/TablaReservas'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import '../styles/reservas.css'
import '../styles/common.css'

const FILTROS_INICIAL = { estado: '', fecha: '', servicio: '' }

function Reservas() {
    const { usuario } = useAuth()
    const { data: empresas, loading: loadingEmpresas } = useFetch(
        () => getEmpresasByUsuario(usuario.id), [usuario.id]
    )
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const { servicios, reservas, loading, refetch } = useReservas(empresaActiva)
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [filtros, setFiltros] = useState(FILTROS_INICIAL)
    const [reservaBorrando, setReservaBorrando] = useState(null)
    const [loadingDelete, setLoadingDelete] = useState(false)

    useEffect(() => {
        if (empresas?.length === 1 && !empresaActiva) setEmpresaActiva(empresas[0])
    }, [empresas])

    const handleCambiarEstado = async (idReserva, nuevoEstado) => {
        try {
            await updateEstado(idReserva, nuevoEstado)
            mostrarExito('Estado actualizado correctamente')
            refetch()
        } catch {
            mostrarError('Error al cambiar el estado.')
        }
    }

    const handleEliminar = async () => {
        setLoadingDelete(true)
        try {
            await deleteReserva(reservaBorrando.id)
            setReservaBorrando(null)
            mostrarExito('Reserva eliminada correctamente')
            refetch()
        } catch {
            mostrarError('Error al eliminar la reserva.')
        } finally {
            setLoadingDelete(false)
        }
    }

    const reservasFiltradas = reservas.filter((r) => {
        if (filtros.estado && r.estado !== filtros.estado) return false
        if (filtros.fecha && r.fecha !== filtros.fecha) return false
        if (filtros.servicio && String(r.idServicio) !== filtros.servicio) return false
        return true
    })

    if (loadingEmpresas) {
        return <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
    }

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Reservas</h4>
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
                    <p>Selecciona una empresa para ver sus reservas</p>
                </div>
            ) : loading ? (
                <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
            ) : (
                <>
                    <FiltrosReservas
                        servicios={servicios}
                        filtros={filtros}
                        onChange={setFiltros}
                        onLimpiar={() => setFiltros(FILTROS_INICIAL)}
                    />
                    <TablaReservas
                        reservas={reservasFiltradas}
                        onCambiarEstado={handleCambiarEstado}
                        onEliminar={setReservaBorrando}
                    />
                </>
            )}

            {reservaBorrando && (
                <ConfirmModal
                    mensaje={`¿Seguro que quieres eliminar la reserva del ${reservaBorrando.fecha} a las ${reservaBorrando.horaInicio?.slice(0, 5)}?`}
                    onConfirmar={handleEliminar}
                    onCerrar={() => setReservaBorrando(null)}
                    loading={loadingDelete}
                />
            )}

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Reservas