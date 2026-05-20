import { useState, useEffect, useCallback } from 'react'
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
                const res = await getReservasByServicio(s.id).catch(() => []) || []
                for (const r of res) {
                    const usuario = await obtenerUsuario(r.idUsuario)
                    r.nombreCliente = usuario ? `${usuario.nombre} ${usuario.apellidos}` : `#${r.idUsuario}`
                    r.telefonoCliente = usuario?.telefono || null

                    if (r.idEmpleados?.length) {
                        const empleadosData = await Promise.all(r.idEmpleados.map(obtenerEmpleado))
                        r.nombresEmpleados = empleadosData
                            .filter(Boolean)
                            .map((e) => `${e.nombre} ${e.apellidos}`)
                    } else {
                        r.nombresEmpleados = []
                    }

                    todasReservas.push({ ...r, nombreServicio: s.nombre })
                }
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