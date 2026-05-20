import {
    ResponsiveContainer, ComposedChart, Bar, Line,
    XAxis, YAxis, CartesianGrid, Tooltip, Legend
} from 'recharts'
import '../../styles/dashboard.css'

function GraficoIngresos({ datos }) {
    return (
        <div className="dashboard-grafico-card">
            <div className="dashboard-grafico-titulo">
                <i className="bi bi-currency-euro me-2 text-primary" />
                Ingresos por semana — últimas 8 semanas
            </div>
            <ResponsiveContainer width="100%" height={window.innerWidth < 576 ? 180 : 220}>
                <ComposedChart data={datos} margin={{ top: 4, right: 8, left: -10, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" vertical={false} />
                    <XAxis
                        dataKey="label"
                        tick={{ fontSize: 11, fill: '#adb5bd' }}
                        tickLine={false}
                        axisLine={false}
                    />
                    <YAxis
                        tick={{ fontSize: 11, fill: '#adb5bd' }}
                        tickLine={false}
                        axisLine={false}
                        tickFormatter={(v) => `${v}€`}
                    />
                    <Tooltip
                        contentStyle={{ borderRadius: 8, border: 'none', boxShadow: '0 2px 8px rgba(0,0,0,0.1)', fontSize: 13 }}
                        formatter={(v, n) => [`${v.toFixed(2)} €`, n]}
                    />
                    <Legend iconType="circle" iconSize={8} wrapperStyle={{ fontSize: 12 }} />
                    <Bar dataKey="finalizado" name="Finalizado" fill="#198754" radius={[4, 4, 0, 0]} maxBarSize={32} stackId="a" />
                    <Bar dataKey="confirmado" name="Confirmado" fill="#0d6efd" radius={[4, 4, 0, 0]} maxBarSize={32} stackId="a" />
                    <Line type="monotone" dataKey="total" name="Total" stroke="#fd7e14" strokeWidth={2} dot={false} activeDot={{ r: 4 }} />
                </ComposedChart>
            </ResponsiveContainer>
        </div>
    )
}

export default GraficoIngresos