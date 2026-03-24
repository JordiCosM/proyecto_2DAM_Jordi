import '../../styles/home.css'

function SelectorFecha({ fecha, onChange }) {
    const hoy = new Date().toISOString().split('T')[0]
    const manana = new Date(Date.now() + 86400000).toISOString().split('T')[0]

    const atajos = [
        { label: 'Hoy', value: hoy },
        { label: 'Mañana', value: manana },
    ]

    return (
        <div className="d-flex align-items-center gap-2 flex-wrap">
            {atajos.map((a) => (
                <button
                    key={a.value}
                    className={`btn btn-sm home-fecha-btn ${fecha === a.value ? 'btn-primary' : 'btn-outline-secondary'}`}
                    onClick={() => onChange(a.value)}
                >
                    {a.label}
                </button>
            ))}
            <input
                type="date"
                className="form-control form-control-sm"
                style={{ width: 160 }}
                value={fecha}
                onChange={(e) => onChange(e.target.value)}
            />
        </div>
    )
}

export default SelectorFecha