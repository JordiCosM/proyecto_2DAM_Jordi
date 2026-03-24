import { useState } from 'react'
import { useNavigate, useSearchParams, Link } from 'react-router-dom'
import { resetPassword } from '../services/authService'
import '../styles/auth.css'

function ResetPassword() {
    const navigate = useNavigate()
    const [searchParams] = useSearchParams()
    const token = searchParams.get('token')

    const [password, setPassword] = useState('')
    const [confirmacion, setConfirmacion] = useState('')
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(false)

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (password !== confirmacion) {
            setError('Las contraseñas no coinciden.')
            return
        }
        setLoading(true)
        setError(null)
        try {
            await resetPassword(token, password)
            navigate('/login')
        } catch (err) {
            setError('El enlace no es válido o ha expirado.')
        } finally {
            setLoading(false)
        }
    }

    if (!token) {
        return (
            <div className="auth-wrapper">
                <div className="card shadow-sm border-0 p-4 text-center" style={{ maxWidth: 420 }}>
                    <p className="text-danger fw-semibold">Enlace no válido.</p>
                    <Link to="/login" className="btn btn-primary mt-2">Volver al inicio</Link>
                </div>
            </div>
        )
    }

    return (
        <div className="auth-wrapper">
            <div className="card auth-card" style={{ width: '100%', maxWidth: 420 }}>
                <div className="card-body p-4">

                    <h4 className="fw-bold mb-1 text-center">Nueva contraseña</h4>
                    <p className="text-muted text-center small mb-4">Elige una contraseña segura</p>

                    {error && <div className="alert alert-danger py-2 small">{error}</div>}

                    <form onSubmit={handleSubmit}>
                        <div className="mb-3">
                            <label className="form-label">Nueva contraseña</label>
                            <input
                                type="password"
                                className="form-control"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                                minLength={8}
                            />
                        </div>
                        <div className="mb-4">
                            <label className="form-label">Confirmar contraseña</label>
                            <input
                                type="password"
                                className="form-control"
                                value={confirmacion}
                                onChange={(e) => setConfirmacion(e.target.value)}
                                required
                                minLength={8}
                            />
                        </div>
                        <button className="btn btn-primary w-100" disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Guardando...</>
                                : 'Cambiar contraseña'}
                        </button>
                    </form>

                </div>
            </div>
        </div>
    )
}

export default ResetPassword