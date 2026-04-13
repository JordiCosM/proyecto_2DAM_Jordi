import '../../styles/dashboard.css'

function KpiCard({ icono, color, fondo, valor, label, sub, subColor }) {
    return (
        <div className="dashboard-kpi-card">
            <div className="d-flex align-items-start gap-3">
                <div className="dashboard-kpi-icono" style={{ background: fondo, color }}>
                    <i className={`bi ${icono}`} />
                </div>
                <div>
                    <div className="dashboard-kpi-valor">{valor}</div>
                    <div className="dashboard-kpi-label">{label}</div>
                    {sub && (
                        <div className="dashboard-kpi-sub" style={{ color: subColor || '#6c757d' }}>{sub}</div>
                    )}
                </div>
            </div>
        </div>
    )
}

export default KpiCard