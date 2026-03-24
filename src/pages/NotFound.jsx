import { useNavigate } from 'react-router-dom'

function NotFound() {
    const navigate = useNavigate()

    return (
        <div className="min-vh-100 d-flex align-items-center justify-content-center bg-light">
            <div className="text-center">
                <div style={{ fontSize: '5rem', fontWeight: 800, color: '#dee2e6' }}>404</div>
                <h5 className="fw-bold mb-2">Página no encontrada</h5>
                <p className="text-muted small mb-4">La página que buscas no existe o ha sido movida.</p>
                <button className="btn btn-primary btn-sm" onClick={() => navigate('/home')}>
                    <i className="bi bi-house me-2" />Volver al inicio
                </button>
            </div>
        </div>
    )
}

export default NotFound