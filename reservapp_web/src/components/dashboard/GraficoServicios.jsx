import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts'
import '../../styles/dashboard.css'

function GraficoServicios({ datos }) {
  return (
    <div className="dashboard-grafico-card">
      <div className="dashboard-grafico-titulo">
        <i className="bi bi-bar-chart me-2 text-primary" />
        Reservas por servicio — histórico
      </div>
      <ResponsiveContainer width="100%" height={window.innerWidth < 576 ? 180 : 220}>
        <BarChart data={datos} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" vertical={false} />
          <XAxis
            dataKey="name"
            tick={{ fontSize: 11, fill: '#adb5bd' }}
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
          />
          <Bar dataKey="total" fill="#0d6efd" radius={[6, 6, 0, 0]} maxBarSize={48} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  )
}

export default GraficoServicios