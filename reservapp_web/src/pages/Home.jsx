import { useState } from 'react'
import useAuth from '../hooks/useAuth'
import useEmpresa from '../hooks/useEmpresa'
import { createEmpresa } from '../services/empresaService'
import useHomeData from '../hooks/useHomeData'
import useToast from '../hooks/useToast'
import Toast from '../components/common/Toast'
import SelectorFecha from '../components/home/SelectorFecha'
import EmpresaReservas from '../components/home/EmpresaReservas'
import CrearEmpresaForm from '../components/home/CrearEmpresaForm'

function Home() {
    const { usuario } = useAuth()
    const { setTieneEmpresa } = useEmpresa()
    const hoy = new Date().toISOString().split('T')[0]
    const [fecha, setFecha] = useState(hoy)
    const { toast, cerrarToast } = useToast()

    const { empresas, datos, loading, error, refetch } = useHomeData(usuario, fecha)

    const handleEmpresaCreada = async (form) => {
        const nueva = await createEmpresa({ ...form, idUsuario: usuario.id })
        setTieneEmpresa(true)
        refetch()
        return nueva
    }

    if (loading) {
        return (
            <div className="d-flex justify-content-center align-items-center" style={{ minHeight: '60vh' }}>
                <div className="text-center">
                    <div className="spinner-border text-primary mb-3" />
                    <p className="text-muted small">Cargando...</p>
                </div>
            </div>
        )
    }

    if (error) return <div className="alert alert-danger">{error}</div>

    if (!empresas.length) {
        if (usuario?.tipo === 'EMPLEADO') {
            return (
                <div className="empty-state">
                    <i className="bi bi-building" />
                    <p>No tienes acceso a ninguna empresa todavía.</p>
                    <p className="text-muted small">Contacta con el administrador de tu empresa.</p>
                </div>
            )
        }
        return <CrearEmpresaForm onEmpresaCreada={handleEmpresaCreada} />
    }

    return (
        <>
            <div className="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-4">
                <h4 className="fw-bold mb-0">Reservas del día</h4>
                <SelectorFecha fecha={fecha} onChange={setFecha} />
            </div>

            {empresas.map((empresa) => (
                <EmpresaReservas
                    key={empresa.id}
                    empresa={empresa}
                    servicios={datos[empresa.id]?.servicios || []}
                    reservasPorServicio={datos[empresa.id]?.reservasPorServicio || {}}
                />
            ))}
            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Home