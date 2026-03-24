import { useState } from 'react'
import { Link } from 'react-router-dom'
import { forgotPassword } from '../services/authService'
import '../styles/auth.css'

function ForgotPassword() {
    const [email, setEmail] = useState('')
    const [enviado, setEnviado] = useState(false)
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(false)

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        try {
            await forgotPassword(email)
            setEnviado(true)
        } catch (err) {
            setError('No encontramos ninguna cuenta con ese email.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="auth-wrapper">
            <div className="card auth-card">
                <div className="card-body">

                    <h4 className="auth-title">Recuperar contraseña</h4>
                    <p className="auth-subtitle">Te enviaremos un enlace a tu email</p>

                    {enviado ? (
                        <div className="text-center py-2">
                            <i className="bi bi-envelope-check text-primary" style={{ fontSize: '3rem' }} />
                            <p className="fw-semibold mt-3">Revisa tu correo</p>
                            <p className="text-muted small">
                                Si el email existe en nuestro sistema, recibirás un enlace para restablecer tu contraseña.
                            </p>
                            <Link to="/login" className="btn btn-primary w-100 mt-2">
                                Volver al inicio de sesión
                            </Link>
                        </div>
                    ) : (
                        <>
                            {error && <div className="alert alert-danger py-2 small">{error}</div>}
                            <form onSubmit={handleSubmit}>
                                <div className="mb-4">
                                    <label className="form-label">Email</label>
                                    <input
                                        type="email"
                                        className="form-control"
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        required
                                    />
                                </div>
                                <button className="btn btn-primary w-100" disabled={loading}>
                                    {loading
                                        ? <><span className="spinner-border spinner-border-sm me-2" />Enviando...</>
                                        : 'Enviar enlace'}
                                </button>
                            </form>
                            <p className="text-center small mt-3 mb-0">
                                <Link to="/login">Volver al inicio de sesión</Link>
                            </p>
                        </>
                    )}

                </div>
            </div>
        </div>
    )
}

export default ForgotPassword