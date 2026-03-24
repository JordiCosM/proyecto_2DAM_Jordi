import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { register as registerService } from '../services/authService'
import '../styles/auth.css'

function Register() {
    const navigate = useNavigate()

    const [form, setForm] = useState({
        nombre: '', apellidos: '', email: '', password: '', telefono: '', rol: 'EMPRESA'
    })
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(false)

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })
    const handleRol = (rol) => setForm({ ...form, rol })

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        try {
            await registerService(form)
            navigate('/login')
        } catch (err) {
            setError('Error al registrarse. Comprueba los datos.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="auth-wrapper">
            <div className="card auth-card">
                <div className="card-body">

                    <h4 className="auth-title">Crear cuenta</h4>
                    <p className="auth-subtitle">Empieza a gestionar tus reservas</p>

                    {error && <div className="alert alert-danger py-2 small">{error}</div>}

                    <form onSubmit={handleSubmit}>

                        <div className="mb-3">
                            <p className="text-muted small mb-2">¿Cómo vas a usar ReservApp?</p>
                            <div className="row g-2">
                                {[
                                    { rol: 'EMPRESA', icono: 'bi-building', titulo: 'Soy empresa', desc: 'Gestiono reservas y servicios' },
                                    { rol: 'CLIENTE', icono: 'bi-person', titulo: 'Soy cliente', desc: 'Hago reservas en negocios' },
                                ].map(({ rol, icono, titulo, desc }) => (
                                    <div className="col-6" key={rol}>
                                        <div
                                            className={`role-btn ${form.rol === rol ? 'selected' : ''}`}
                                            onClick={() => handleRol(rol)}
                                        >
                                            <div className="role-btn-icon">
                                                <i className={`bi ${icono}`} />
                                            </div>
                                            <p className="role-btn-title">{titulo}</p>
                                            <p className="role-btn-desc">{desc}</p>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>

                        <div className="row g-3">
                            <div className="col-6">
                                <label className="form-label">Nombre</label>
                                <input name="nombre" className="form-control" value={form.nombre} onChange={handleChange} required />
                            </div>
                            <div className="col-6">
                                <label className="form-label">Apellidos</label>
                                <input name="apellidos" className="form-control" value={form.apellidos} onChange={handleChange} required />
                            </div>
                            <div className="col-12">
                                <label className="form-label">Email</label>
                                <input type="email" name="email" className="form-control" value={form.email} onChange={handleChange} required />
                            </div>
                            <div className="col-12">
                                <label className="form-label">Contraseña</label>
                                <input type="password" name="password" className="form-control" value={form.password} onChange={handleChange} required minLength={8} />
                            </div>
                            <div className="col-12">
                                <label className="form-label">Teléfono</label>
                                <input name="telefono" className="form-control" value={form.telefono} onChange={handleChange} required />
                            </div>
                        </div>

                        <button className="btn btn-primary w-100 mt-4" disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Registrando...</>
                                : 'Crear cuenta'}
                        </button>
                    </form>

                    <p className="text-center small mt-3 mb-0">
                        ¿Ya tienes cuenta? <Link to="/login">Inicia sesión</Link>
                    </p>

                </div>
            </div>
        </div>
    )
}

export default Register