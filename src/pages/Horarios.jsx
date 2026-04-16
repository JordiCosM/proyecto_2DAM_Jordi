import { useState, useEffect } from 'react'
import useAuth from '../hooks/useAuth'
import { getHorariosByEmpresa, createHorario, updateHorario, deleteHorario } from '../services/horarioService'
import useFetch from '../hooks/useFetch'
import useToast from '../hooks/useToast'
import useEmpresas from '../hooks/useEmpresas'
import HorarioFormModal from '../components/horarios/HorarioFormModal'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import SpinnerPage from '../components/common/SpinnerPage'
import EmptyState from '../components/common/EmptyState'
import EmpresaSelector from '../components/common/EmpresaSelector'
import { puedeEditar } from '../utils/permisos'
import '../styles/horarios.css'
import '../styles/common.css'

const DIAS_ORDEN = ['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO']

function Horarios() {
    const { usuario } = useAuth()
    const { data: empresas, loading: loadingEmpresas } = useEmpresas()
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const { data: horarios, loading: loadingHorarios, refetch } = useFetch(
        () => empresaActiva ? getHorariosByEmpresa(empresaActiva.id) : Promise.resolve([]),
        [empresaActiva?.id]
    )
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()
    const [modalForm, setModalForm] = useState(false)
    const [horarioEditando, setHorarioEditando] = useState(null)
    const [horarioBorrando, setHorarioBorrando] = useState(null)
    const [loadingDelete, setLoadingDelete] = useState(false)

    const canEdit = puedeEditar(usuario)

    useEffect(() => {
        if (empresas?.length && !empresaActiva) setEmpresaActiva(empresas[0])
    }, [empresas])

    const handleGuardar = async (form) => {
        try {
            if (horarioEditando) {
                await updateHorario(horarioEditando.id, form)
            } else {
                await createHorario(form)
            }
            setModalForm(false)
            setHorarioEditando(null)
            mostrarExito('Horario guardado correctamente')
            refetch()
        } catch {
            mostrarError('Error al guardar el horario.')
        }
    }

    const handleEliminar = async () => {
        setLoadingDelete(true)
        try {
            await deleteHorario(horarioBorrando.id)
            setHorarioBorrando(null)
            mostrarExito('Horario eliminado correctamente')
            refetch()
        } catch {
            mostrarError('Error al eliminar el horario.')
        } finally {
            setLoadingDelete(false)
        }
    }

    const abrirEditar = (horario) => { setHorarioEditando(horario); setModalForm(true) }
    const abrirNuevo = () => { setHorarioEditando(null); setModalForm(true) }

    const horarioOrdenado = [...(horarios || [])].sort(
        (a, b) => DIAS_ORDEN.indexOf(a.dia) - DIAS_ORDEN.indexOf(b.dia)
    )
    const diasConHorario = horarios?.map((h) => h.dia) || []

    if (loadingEmpresas) return <SpinnerPage />

    return (
        <>
            {canEdit && empresaActiva && diasConHorario.length < 7 && (
                <div className="d-flex align-items-center justify-content-between mb-4">
                    <h4 className="fw-bold mb-0">Horarios</h4>
                    {empresaActiva && diasConHorario.length < 7 && (
                        <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                            <i className="bi bi-plus-lg me-1" />Añadir horario
                        </button>
                    )}
                </div>
            )}

            <EmpresaSelector
                empresas={empresas}
                empresaActiva={empresaActiva}
                onSeleccionar={setEmpresaActiva}
            />

            {!empresaActiva ? (
                <EmptyState icono="bi-building" texto="Selecciona una empresa para ver sus horarios" />
            ) : loadingHorarios ? (
                <SpinnerPage />
            ) : !horarioOrdenado.length ? (
                <EmptyState icono="bi-grid" texto="Esta empresa no tiene horarios configurados">
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Añadir horario
                    </button>
                </EmptyState>
            ) : (
                <div className="card horario-card">
                    <div className="card-body px-4">
                        {horarioOrdenado.map((horario) => (
                            <div key={horario.id} className="horario-row ">
                                <span className="dia-badge">
                                    {horario.dia.charAt(0) + horario.dia.slice(1).toLowerCase()}
                                </span>
                                <div className="horario-horas">
                                    <i className="bi bi-door-open text-success" />
                                    <span>{horario.apertura?.slice(0, 5)}</span>
                                    <span className="horario-separador">→</span>
                                    <i className="bi bi-door-closed text-danger" />
                                    <span>{horario.cierre?.slice(0, 5)}</span>
                                </div>
                                {canEdit && (
                                    <div className="d-flex gap-2 mx-auto mx-md-0">
                                        <button className="btn btn-outline-primary btn-sm" onClick={() => abrirEditar(horario)}>
                                            <i className="bi bi-pencil" />
                                        </button>
                                        <button className="btn btn-outline-danger btn-sm" onClick={() => setHorarioBorrando(horario)}>
                                            <i className="bi bi-trash" />
                                        </button>
                                    </div>
                                )}
                            </div>
                        ))}
                    </div>
                </div>
            )}

            <HorarioFormModal
                show={modalForm}
                horario={horarioEditando}
                idEmpresa={Number(empresaActiva?.id)}
                diasOcupados={diasConHorario}
                onGuardar={handleGuardar}
                onCerrar={() => { setModalForm(false); setHorarioEditando(null) }}
            />

            <ConfirmModal
                show={!!horarioBorrando}
                mensaje={`¿Seguro que quieres eliminar el horario del ${horarioBorrando?.dia?.charAt(0) + horarioBorrando?.dia?.slice(1).toLowerCase()}?`}
                onConfirmar={handleEliminar}
                onCerrar={() => setHorarioBorrando(null)}
                loading={loadingDelete}
            />

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Horarios