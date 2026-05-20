import { useState, useEffect } from 'react'
import useEmpresas from '../hooks/useEmpresas'
import { updateEstado, deleteReserva } from '../services/reservaService'
import useReservas from '../hooks/useReservas'
import useToast from '../hooks/useToast'
import FiltrosReservas from '../components/reservas/FiltrosReservas'
import TablaReservas from '../components/reservas/TablaReservas'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import SpinnerPage from '../components/common/SpinnerPage'
import EmptyState from '../components/common/EmptyState'
import EmpresaSelector from '../components/common/EmpresaSelector'
import ReservaFormModal from '../components/reservas/ReservaFormModal'
import ReservaEditModal from '../components/reservas/ReservaEditModal'
import '../styles/reservas.css'
import '../styles/common.css'

const FILTROS_INICIAL = { estado: '', fecha: '', servicio: '' }

function Reservas() {
    const { data: empresas, loading: loadingEmpresas } = useEmpresas()
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const { servicios, reservas, loading, refetch } = useReservas(empresaActiva)
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [filtros, setFiltros] = useState(FILTROS_INICIAL)
    const [reservaBorrando, setReservaBorrando] = useState(null)
    const [loadingDelete, setLoadingDelete] = useState(false)
    const [modalNuevaReserva, setModalNuevaReserva] = useState(false)
    const [reservaEditando, setReservaEditando] = useState(null)

    useEffect(() => {
        if (empresas?.length && !empresaActiva) setEmpresaActiva(empresas[0])
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

    const handleNuevaReserva = async () => {
        setModalNuevaReserva(false)
        mostrarExito('Reserva creada correctamente')
        refetch()
    }

    const handleGuardarEmpleados = async () => {
        setReservaEditando(null)
        mostrarExito('Empleados actualizados correctamente')
        refetch()
    }

    const reservasFiltradas = reservas.filter((r) => {
        if (filtros.estado && r.estado !== filtros.estado) return false
        if (filtros.fecha && r.fecha !== filtros.fecha) return false
        if (filtros.servicio && String(r.idServicio) !== filtros.servicio) return false
        return true
    })

    if (loadingEmpresas) return <SpinnerPage />

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Reservas</h4>
                {empresaActiva && (
                    <button className="btn btn-primary btn-sm" onClick={() => setModalNuevaReserva(true)}>
                        <i className="bi bi-plus-lg me-1" />Nueva reserva
                    </button>
                )}
            </div>

            <EmpresaSelector
                empresas={empresas}
                empresaActiva={empresaActiva}
                onSeleccionar={setEmpresaActiva}
            />

            {!empresaActiva ? (
                <EmptyState icono="bi-building" texto="Selecciona una empresa para ver sus reservas" />
            ) : loading ? (
                <SpinnerPage />
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
                        onEditarEmpleados={setReservaEditando}
                    />
                </>
            )}

            <ConfirmModal
                show={!!reservaBorrando}
                mensaje={`¿Seguro que quieres eliminar la reserva del ${reservaBorrando?.fecha} a las ${reservaBorrando?.horaInicio?.slice(0, 5)}?`}
                onConfirmar={handleEliminar}
                onCerrar={() => setReservaBorrando(null)}
                loading={loadingDelete}
            />

            <ReservaFormModal
                show={modalNuevaReserva}
                idEmpresa={empresaActiva?.id}
                onGuardar={handleNuevaReserva}
                onCerrar={() => setModalNuevaReserva(false)}
            />

            <ReservaEditModal
                show={!!reservaEditando}
                reserva={reservaEditando}
                idEmpresa={empresaActiva?.id}
                onGuardar={handleGuardarEmpleados}
                onCerrar={() => setReservaEditando(null)}
            />

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Reservas