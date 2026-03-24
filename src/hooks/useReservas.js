import { useState, useEffect, useCallback } from 'react'
import { getServiciosByEmpresa } from '../services/servicioService'
import { getReservasByServicio } from '../services/reservaService'

function useReservas(empresaActiva) {
    const [servicios, setServicios] = useState([])
    const [reservas, setReservas] = useState([])
    const [loading, setLoading] = useState(false)

    const cargarDatos = useCallback(async () => {
        if (!empresaActiva) return
        setLoading(true)
        try {
            const svcs = await getServiciosByEmpresa(empresaActiva.id) || []
            setServicios(svcs)

            const todasReservas = []
            for (const s of svcs) {
                const res = await getReservasByServicio(s.id) || []
                res.forEach((r) => todasReservas.push({ ...r, nombreServicio: s.nombre }))
            }
            todasReservas.sort((a, b) => {
                if (a.fecha !== b.fecha) return b.fecha.localeCompare(a.fecha)
                return b.horaInicio.localeCompare(a.horaInicio)
            })
            setReservas(todasReservas)
        } finally {
            setLoading(false)
        }
    }, [empresaActiva?.id])

    useEffect(() => {
        cargarDatos()
    }, [cargarDatos])

    return { servicios, reservas, loading, refetch: cargarDatos }
}

export default useReservas