import '../../styles/perfil.css'

function DangerZone({ onEliminar }) {
    return (
        <div className="danger-zone">
            <div className="d-flex align-items-start justify-content-between gap-3">
                <div>
                    <p className="fw-semibold text-danger mb-1">Eliminar cuenta</p>
                    <p className="text-muted small mb-0">
                        Esta acción eliminará permanentemente tu cuenta y todos tus datos. No se puede deshacer.
                    </p>
                </div>
                <button
                    className="btn btn-outline-danger btn-sm flex-shrink-0"
                    onClick={onEliminar}
                >
                    <i className="bi bi-trash me-1" />Eliminar
                </button>
            </div>
        </div>
    )
}

export default DangerZone