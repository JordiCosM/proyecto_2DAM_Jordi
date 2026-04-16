import { useState, useMemo } from 'react'
import '../../styles/calendario.css'

const DIAS_NOMBRE = ['L', 'M', 'X', 'J', 'V', 'S', 'D']

function CalendarioDisponibilidad({ getEstadoDia, fechaSeleccionada, onSelectFecha }) {
    const hoy = new Date(); hoy.setHours(0, 0, 0, 0)
    const [mes, setMes] = useState(() => {
        const d = new Date(); return { anio: d.getFullYear(), mes: d.getMonth() }
    })

    const dias = useMemo(() => {
        const primero = new Date(mes.anio, mes.mes, 1)
        const ultimo = new Date(mes.anio, mes.mes + 1, 0)
        // lunes=0 ... domingo=6
        const inicioSem = (primero.getDay() + 6) % 7
        const celdas = []
        for (let i = 0; i < inicioSem; i++) celdas.push(null)
        for (let d = 1; d <= ultimo.getDate(); d++) celdas.push(d)
        return celdas
    }, [mes])

    const toFecha = (dia) => {
        const m = String(mes.mes + 1).padStart(2, '0')
        const d = String(dia).padStart(2, '0')
        return `${mes.anio}-${m}-${d}`
    }

    const titulo = new Date(mes.anio, mes.mes, 1)
        .toLocaleString('es-ES', { month: 'long', year: 'numeric' })

    const irAnterior = () => setMes((p) => {
        const d = new Date(p.anio, p.mes - 1, 1)
        return { anio: d.getFullYear(), mes: d.getMonth() }
    })

    const irSiguiente = () => setMes((p) => {
        const d = new Date(p.anio, p.mes + 1, 1)
        return { anio: d.getFullYear(), mes: d.getMonth() }
    })

    const esHoy = (dia) => {
        const f = new Date(mes.anio, mes.mes, dia)
        return f.getTime() === hoy.getTime()
    }

    const handleClick = (dia) => {
        if (!dia) return
        const fecha = toFecha(dia)
        const estado = getEstadoDia(fecha)
        if (estado === 'disponible') onSelectFecha(fecha)
    }

    return (
        <div className="cal-wrapper">
            <div className="cal-header">
                <button className="cal-nav" type="button" onClick={irAnterior}>
                    <i className="bi bi-chevron-left" />
                </button>
                <span className="cal-titulo">{titulo}</span>
                <button className="cal-nav" type="button" onClick={irSiguiente}>
                    <i className="bi bi-chevron-right" />
                </button>
            </div>

            <div className="cal-grid">
                {DIAS_NOMBRE.map((d) => (
                    <div key={d} className="cal-dia-nombre">{d}</div>
                ))}

                {dias.map((dia, i) => {
                    if (!dia) return <div key={`v-${i}`} className="cal-dia vacio" />
                    const fecha = toFecha(dia)
                    const estado = getEstadoDia(fecha)
                    const sel = fecha === fechaSeleccionada
                    return (
                        <div
                            key={dia}
                            className={[
                                'cal-dia',
                                estado,
                                sel ? 'seleccionado' : '',
                                esHoy(dia) ? 'hoy' : '',
                            ].join(' ')}
                            onClick={() => handleClick(dia)}
                            title={estado === 'cerrado' ? 'Cerrado' : estado === 'lleno' ? 'Sin disponibilidad' : ''}
                        >
                            {dia}
                        </div>
                    )
                })}
            </div>

            <div className="cal-leyenda">
                <div className="cal-leyenda-item">
                    <div className="cal-leyenda-dot" style={{ background: '#86efac', border: '1px solid #4ade80' }} />
                    Disponible
                </div>
                <div className="cal-leyenda-item">
                    <div className="cal-leyenda-dot" style={{ background: '#fca5a5', border: '1px solid #f87171' }} />
                    Sin plazas
                </div>
                <div className="cal-leyenda-item">
                    <div className="cal-leyenda-dot" style={{ background: '#f8f9fa', border: '1px solid #dee2e6' }} />
                    Cerrado
                </div>
            </div>
        </div>
    )
}

export default CalendarioDisponibilidad