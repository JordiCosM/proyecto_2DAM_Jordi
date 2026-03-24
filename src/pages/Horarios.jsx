import { useState, useEffect } from 'react'
import { useAuth } from '../context/AuthContext'
import { getEmpresasByUsuario } from '../services/empresaService'
import { getHorariosByEmpresa, createHorario, updateHorario, deleteHorario } from '../services/horarioService'
import useFetch from '../hooks/useFetch'
import useToast from '../hooks/useToast'
import HorarioFormModal from '../components/horarios/HorarioFormModal'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import '../styles/horarios.css'
import '../styles/common.css'

const DIAS_ORDEN = ['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO']

function Horarios() {
    const { usuario } = useAuth()
    const { data: empresas, loading: loadingEmpresas } = useFetch(
        () => getEmpresasByUsuario(usuario.id), [usuario.id]
    )
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

    useEffect(() => {
        if (empresas?.length === 1 && !empresaActiva) setEmpresaActiva(empresas[0])
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

    if (loadingEmpresas) {
        return <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
    }

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Horarios</h4>
                {empresaActiva && diasConHorario.length < 7 && (
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Añadir horario
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
                    <p>Selecciona una empresa para ver sus horarios</p>
                </div>
            ) : loadingHorarios ? (
                <div className="spinner-fullpage"><div className="spinner-border text-primary" /></div>
            ) : !horarioOrdenado.length ? (
                <div className="empty-state">
                    <i className="bi bi-clock" />
                    <p>Esta empresa no tiene horarios configurados</p>
                    <button className="btn btn-primary btn-sm" onClick={abrirNuevo}>
                        <i className="bi bi-plus-lg me-1" />Añadir horario
                    </button>
                </div>
            ) : (
                <div className="card horario-card">
                    <div className="card-body px-4">
                        {horarioOrdenado.map((horario) => (
                            <div key={horario.id} className="horario-row">
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
                                <div className="d-flex gap-2">
                                    <button className="btn btn-outline-primary btn-sm" onClick={() => abrirEditar(horario)}>
                                        <i className="bi bi-pencil" />
                                    </button>
                                    <button className="btn btn-outline-danger btn-sm" onClick={() => setHorarioBorrando(horario)}>
                                        <i className="bi bi-trash" />
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {modalForm && (
                <HorarioFormModal
                    horario={horarioEditando}
                    idEmpresa={empresaActiva?.id}
                    onGuardar={handleGuardar}
                    onCerrar={() => { setModalForm(false); setHorarioEditando(null) }}
                />
            )}

            {horarioBorrando && (
                <ConfirmModal
                    mensaje={`¿Seguro que quieres eliminar el horario del ${horarioBorrando.dia.charAt(0) + horarioBorrando.dia.slice(1).toLowerCase()}?`}
                    onConfirmar={handleEliminar}
                    onCerrar={() => setHorarioBorrando(null)}
                    loading={loadingDelete}
                />
            )}

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Horarios