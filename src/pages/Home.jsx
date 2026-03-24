import { useState } from 'react'
import { useAuth } from '../context/AuthContext'
import { useEmpresa } from '../context/EmpresaContext'
import { updateEstado } from '../services/reservaService'
import { createEmpresa } from '../services/empresaService'
import useHomeData from '../hooks/useHomeData'
import SelectorFecha from '../components/home/SelectorFecha'
import EmpresaReservas from '../components/home/EmpresaReservas'
import CrearEmpresaForm from '../components/home/CrearEmpresaForm'

function Home() {
    const { usuario } = useAuth()
    const { setTieneEmpresa } = useEmpresa()
    const hoy = new Date().toISOString().split('T')[0]
    const [fecha, setFecha] = useState(hoy)

    const { empresas, datos, loading, error, refetch } = useHomeData(usuario.id, fecha)

    const handleCambiarEstado = async (idReserva, nuevoEstado) => {
        try {
            await updateEstado(idReserva, nuevoEstado)
            refetch()
        } catch {
            alert('Error al cambiar el estado de la reserva.')
        }
    }

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
                    onCambiarEstado={handleCambiarEstado}
                />
            ))}
        </>
    )
}

export default Home