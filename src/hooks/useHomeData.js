import { useState, useEffect, useCallback } from 'react'
import { getEmpresasByUsuario, getEmpresa } from '../services/empresaService'
import { getServiciosByEmpresa } from '../services/servicioService'
import { getReservasByServicio } from '../services/reservaService'
import { getUsuario } from '../services/usuarioService'
import { getEmpleado } from '../services/empleadoService'

const cacheUsuarios = {}
const cacheEmpleados = {}

async function obtenerUsuario(id) {
    if (cacheUsuarios[id]) return cacheUsuarios[id]
    const u = await getUsuario(id).catch(() => null)
    cacheUsuarios[id] = u
    return u
}

async function obtenerEmpleado(id) {
    if (cacheEmpleados[id]) return cacheEmpleados[id]
    const e = await getEmpleado(id).catch(() => null)
    cacheEmpleados[id] = e
    return e
}

function useHomeData(usuario, fecha) {
    const [empresas, setEmpresas] = useState([])
    const [datos, setDatos] = useState({})
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState(null)

    const cargarEmpresas = useCallback(async () => {
        setLoading(true)
        try {
            let resultado
            if (usuario?.tipo === 'EMPLEADO') {
                const empresa = await getEmpresa(usuario.idEmpresa)
                resultado = empresa ? [empresa] : []
            } else {
                resultado = await getEmpresasByUsuario(usuario.id) || []
            }
            setEmpresas(resultado)
        } catch {
            setError('Error al cargar las empresas.')
        } finally {
            setLoading(false)
        }
    }, [usuario?.id, usuario?.tipo, usuario?.idEmpresa])

    const cargarReservas = useCallback(async (listaEmpresas) => {
        const nuevoDatos = {}
        for (const empresa of listaEmpresas) {
            const servicios = await getServiciosByEmpresa(empresa.id) || []
            const reservasPorServicio = {}

            for (const servicio of servicios) {
                const todas = await getReservasByServicio(servicio.id).catch(() => [])
                const filtradas = todas.filter((r) => r.fecha === fecha)

                for (const r of filtradas) {
                    const u = await obtenerUsuario(r.idUsuario)

                    r.nombreCliente = u ? `${u.nombre} ${u.apellidos}` : `#${r.idUsuario}`
                    r.telefonoCliente = u?.telefono || Nullimport('recharts/types/util/types').ableCoordinate
                    if (r.idEmpleados?.length) {
                        const empleadosData = await Promise.all(r.idEmpleados.map(obtenerEmpleado))

                        r.nombresEmpleados = empleadosData
                            .filter(Boolean)
                            .map((e) => `${e.nombre} ${e.apellidos}`)
                    } else {
                        r.nombresEmpleados = []
                    }
                }
                reservasPorServicio[servicio.id] = filtradas
            }
            nuevoDatos[empresa.id] = { servicios, reservasPorServicio }
        }
        setDatos(nuevoDatos)
    }, [fecha])

    useEffect(() => {
        if (usuario) cargarEmpresas()
    }, [cargarEmpresas])

    useEffect(() => {
        if (empresas.length > 0) cargarReservas(empresas)
    }, [empresas, cargarReservas])

    return { empresas, datos, loading, error, refetch: cargarEmpresas }
}

export default useHomeData