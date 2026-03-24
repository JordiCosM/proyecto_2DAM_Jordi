import { useState, useEffect, useCallback } from 'react'
import { getEmpresasByUsuario } from '../services/empresaService'
import { getServiciosByEmpresa } from '../services/servicioService'
import { getReservasByServicio } from '../services/reservaService'

function useHomeData(idUsuario, fecha) {
    const [empresas, setEmpresas] = useState([])
    const [datos, setDatos] = useState({})
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState(null)

    const cargarEmpresas = useCallback(async () => {
        setLoading(true)
        try {
            const resultado = await getEmpresasByUsuario(idUsuario)
            setEmpresas(resultado || [])
        } catch {
            setError('Error al cargar las empresas.')
        } finally {
            setLoading(false)
        }
    }, [idUsuario])

    const cargarReservas = useCallback(async (listaEmpresas) => {
        const nuevoDatos = {}
        for (const empresa of listaEmpresas) {
            const servicios = await getServiciosByEmpresa(empresa.id) || []
            const reservasPorServicio = {}
            for (const servicio of servicios) {
                const todas = await getReservasByServicio(servicio.id) || []
                reservasPorServicio[servicio.id] = todas.filter((r) => r.fecha === fecha)
            }
            nuevoDatos[empresa.id] = { servicios, reservasPorServicio }
        }
        setDatos(nuevoDatos)
    }, [fecha])

    useEffect(() => {
        cargarEmpresas()
    }, [cargarEmpresas])

    useEffect(() => {
        if (empresas.length > 0) cargarReservas(empresas)
    }, [empresas, cargarReservas])

    return { empresas, datos, loading, error, refetch: cargarEmpresas }
}

export default useHomeData