import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip, Legend } from 'recharts'
import '../../styles/dashboard.css'

function GraficoEstados({ datos }) {
    if (!datos.length) {
        return (
            <div className="dashboard-grafico-card d-flex flex-column align-items-center justify-content-center" style={{ minHeight: 280 }}>
                <i className="bi bi-pie-chart text-muted" style={{ fontSize: '2rem' }} />
                <p className="text-muted small mt-2">Sin datos este mes</p>
            </div>
        )
    }

    return (
        <div className="dashboard-grafico-card">
            <div className="dashboard-grafico-titulo">
                <i className="bi bi-pie-chart me-2 text-primary" />
                Reservas por estado — mes actual
            </div>
            <ResponsiveContainer width="100%" height={window.innerWidth < 576 ? 200 : 260}>
                <PieChart margin={{ top: 10, right: 10, bottom: 10, left: 10 }}>
                    <Pie
                        data={datos}
                        cx="50%"
                        cy="45%"
                        innerRadius={50}
                        outerRadius={75}
                        paddingAngle={3}
                        dataKey="value"
                    >
                        {datos.map((entry, index) => (
                            <Cell key={index} fill={entry.color} />
                        ))}
                    </Pie>
                    <Tooltip
                        contentStyle={{ borderRadius: 8, border: 'none', boxShadow: '0 2px 8px rgba(0,0,0,0.1)', fontSize: 13 }}
                        formatter={(v, n) => [v, n]}
                    />
                    <Legend
                        iconType="circle"
                        iconSize={8}
                        wrapperStyle={{ fontSize: 12 }}
                    />
                </PieChart>
            </ResponsiveContainer>
        </div>
    )
}

export default GraficoEstados