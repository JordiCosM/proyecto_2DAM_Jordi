function EmpresaSelector({ empresas, empresaActiva, onSeleccionar }) {
    if (!empresas || empresas.length <= 1) return null

    return (
        <div className="mb-4">
            <p className="text-muted small mb-2">Selecciona una empresa</p>
            <div className="d-flex flex-wrap gap-2">
                {empresas.map((e) => (
                    <button
                        key={e.id}
                        className={`empresa-selector-btn ${empresaActiva?.id === e.id ? 'selected' : ''}`}
                        onClick={() => onSeleccionar(e)}
                    >
                        <i className="bi bi-building me-2" />{e.nombre}
                    </button>
                ))}
            </div>
        </div>
    )
}

export default EmpresaSelector