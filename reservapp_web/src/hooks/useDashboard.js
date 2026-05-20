import { useState, useEffect, useCallback } from 'react'
import { getServiciosByEmpresa } from '../services/servicioService'
import { getReservasByServicio } from '../services/reservaService'

function useDashboard(empresa) {
    const [datos, setDatos] = useState(null)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    const calcular = useCallback(async () => {
        if (!empresa) return
        setLoading(true)
        setError(null)

        try {
            const servicios = await getServiciosByEmpresa(empresa.id) || []

            const todasReservas = []
            for (const servicio of servicios) {
                const reservas = await getReservasByServicio(servicio.id) || []
                reservas.forEach((r) => todasReservas.push({
                    ...r,
                    nombreServicio: servicio.nombre,
                    precioServicio: servicio.precio,
                }))
            }

            const hoy = new Date()
            const inicioMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1).toISOString().split('T')[0]
            const finMes = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0).toISOString().split('T')[0]

            const delMes = todasReservas.filter((r) => r.fecha >= inicioMes && r.fecha <= finMes)

            // KPIs
            const totalMes = delMes.length
            const confirmadas = delMes.filter((r) => r.estado === 'CONFIRMADA').length
            const canceladas = delMes.filter((r) => r.estado === 'CANCELADA').length
            const finalizadas = delMes.filter((r) => r.estado === 'FINALIZADA').length
            const pendientes = delMes.filter((r) => r.estado === 'PENDIENTE').length

            const ingresoFinalizado = delMes
                .filter((r) => r.estado === 'FINALIZADA')
                .reduce((acc, r) => acc + (r.precioServicio || 0), 0)
            const ingresoConfirmado = delMes
                .filter((r) => r.estado === 'CONFIRMADA')
                .reduce((acc, r) => acc + (r.precioServicio || 0), 0)

            // Servicio más popular
            const porServicio = {}
            todasReservas.forEach((r) => {
                porServicio[r.nombreServicio] = (porServicio[r.nombreServicio] || 0) + 1
            })
            const servicioTop = Object.entries(porServicio).sort((a, b) => b[1] - a[1])[0]?.[0] || '—'

            // Reservas por día
            const reservasPorDia = []
            for (let i = 29; i >= 0; i--) {
                const d = new Date()
                d.setDate(d.getDate() - i)
                const fecha = d.toISOString().split('T')[0]
                const label = `${d.getDate()}/${d.getMonth() + 1}`
                const total = todasReservas.filter((r) => r.fecha === fecha).length
                reservasPorDia.push({ fecha, label, total })
            }

            // Reservas por estado
            const reservasPorEstado = [
                { name: 'Pendiente', value: pendientes, color: '#ffc107' },
                { name: 'Confirmada', value: confirmadas, color: '#0d6efd' },
                { name: 'Cancelada', value: canceladas, color: '#dc3545' },
                { name: 'Finalizada', value: finalizadas, color: '#198754' },
            ].filter((e) => e.value > 0)

            // Reservas por servicio
            const reservasPorServicio = Object.entries(porServicio)
                .map(([name, total]) => ({ name, total }))
                .sort((a, b) => b.total - a.total)
                .slice(0, 6)

            // Ingresos por semana
            const ingresosPorSemana = []
            for (let i = 7; i >= 0; i--) {
                const inicioSemana = new Date()
                inicioSemana.setDate(inicioSemana.getDate() - i * 7 - inicioSemana.getDay())
                const finSemana = new Date(inicioSemana)
                finSemana.setDate(finSemana.getDate() + 6)

                const ini = inicioSemana.toISOString().split('T')[0]
                const fin = finSemana.toISOString().split('T')[0]
                const label = `${inicioSemana.getDate()}/${inicioSemana.getMonth() + 1}`

                const semanaReservas = todasReservas.filter((r) => r.fecha >= ini && r.fecha <= fin)

                const finalizado = semanaReservas
                    .filter((r) => r.estado === 'FINALIZADA')
                    .reduce((acc, r) => acc + (r.precioServicio || 0), 0)
                const confirmado = semanaReservas
                    .filter((r) => r.estado === 'CONFIRMADA')
                    .reduce((acc, r) => acc + (r.precioServicio || 0), 0)

                ingresosPorSemana.push({ label, finalizado, confirmado, total: finalizado + confirmado })
            }

            setDatos({
                kpis: { totalMes, confirmadas, canceladas, finalizadas, pendientes, ingresoFinalizado, ingresoConfirmado, servicioTop },
                reservasPorDia,
                reservasPorEstado,
                reservasPorServicio,
                ingresosPorSemana,
            })
        } catch {
            setError('Error al cargar los datos del dashboard.')
        } finally {
            setLoading(false)
        }
    }, [empresa?.id])

    useEffect(() => {
        calcular()
    }, [calcular])

    return { datos, loading, error, refetch: calcular }
}

export default useDashboard