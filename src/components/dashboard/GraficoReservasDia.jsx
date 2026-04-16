import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts'
import '../../styles/dashboard.css'

function GraficoReservasDia({ datos }) {
    return (
        <div className="dashboard-grafico-card">
            <div className="dashboard-grafico-titulo">
                <i className="bi bi-graph-up me-2 text-primary" />
                Reservas por día — últimos 30 días
            </div>
            <ResponsiveContainer width="100%" height={window.innerWidth < 576 ? 180 : 220}>
                <LineChart data={datos} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
                    <XAxis
                        dataKey="label"
                        tick={{ fontSize: 11, fill: '#adb5bd' }}
                        interval={4}
                        tickLine={false}
                        axisLine={false}
                    />
                    <YAxis
                        allowDecimals={false}
                        tick={{ fontSize: 11, fill: '#adb5bd' }}
                        tickLine={false}
                        axisLine={false}
                    />
                    <Tooltip
                        contentStyle={{ borderRadius: 8, border: 'none', boxShadow: '0 2px 8px rgba(0,0,0,0.1)', fontSize: 13 }}
                        formatter={(v) => [v, 'Reservas']}
                        labelFormatter={(l) => `Día ${l}`}
                    />
                    <Line
                        type="monotone"
                        dataKey="total"
                        stroke="#0d6efd"
                        strokeWidth={2}
                        dot={false}
                        activeDot={{ r: 4 }}
                    />
                </LineChart>
            </ResponsiveContainer>
        </div>
    )
}

export default GraficoReservasDia