import { useState, useEffect, useCallback } from 'react'
import { getHorariosByEmpresa } from '../services/horarioService'
import { getReservasByServicio } from '../services/reservaService'

const DIA_MAP = {
    0: 'DOMINGO', 1: 'LUNES', 2: 'MARTES', 3: 'MIERCOLES',
    4: 'JUEVES', 5: 'VIERNES', 6: 'SABADO',
}

function generarSlots(apertura, cierre, duracionMin) {
    const slots = []
    const [hA, mA] = apertura.slice(0, 5).split(':').map(Number)
    const [hC, mC] = cierre.slice(0, 5).split(':').map(Number)
    let actual = hA * 60 + mA
    const fin = hC * 60 + mC
    while (actual + duracionMin <= fin) {
        const h = String(Math.floor(actual / 60)).padStart(2, '0')
        const m = String(actual % 60).padStart(2, '0')
        slots.push(`${h}:${m}`)
        actual += duracionMin
    }
    return slots
}

function useDisponibilidad(idEmpresa, servicio) {
    const [horarios, setHorarios] = useState([])
    const [reservas, setReservas] = useState([])
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        if (!idEmpresa || !servicio?.id) return
        setLoading(true)
        Promise.all([
            getHorariosByEmpresa(idEmpresa),
            getReservasByServicio(servicio.id).catch(() => []),
        ]).then(([h, r]) => {
            setHorarios(h || [])
            setReservas(r || [])
        }).finally(() => setLoading(false))
    }, [idEmpresa, servicio?.id])

    const getHorarioForDate = useCallback((fecha) => {
        const dia = DIA_MAP[new Date(fecha + 'T00:00:00').getDay()]
        return horarios.find((h) => h.dia === dia) || null
    }, [horarios])

    const getSlotsForDate = useCallback((fecha) => {
        const horario = getHorarioForDate(fecha)
        if (!horario || !servicio) return []
        const slots = generarSlots(horario.apertura, horario.cierre, servicio.duracion)
        const reservasDia = reservas.filter((r) => r.fecha === fecha)

        return slots.map((hora) => {
            const reservasDiaHora = reservasDia.filter((r) => r.horaInicio.slice(0, 5) === hora).length
            const capacidad = servicio.capacidad ?? 1

            return { hora, disponible: reservasDiaHora < capacidad, ocupadas: reservasDiaHora, capacidad }
        })
    }, [horarios, reservas, servicio, getHorarioForDate])

    const getEstadoDia = useCallback((fecha) => {
        const hoy = new Date(); hoy.setHours(0, 0, 0, 0)
        if (new Date(fecha + 'T00:00:00') < hoy) return 'pasado'
        const slots = getSlotsForDate(fecha)
        if (!slots.length) return 'cerrado'
        if (slots.every((s) => !s.disponible)) return 'lleno'
        return 'disponible'
    }, [getSlotsForDate])

    return { loading, getSlotsForDate, getEstadoDia }
}

export default useDisponibilidad