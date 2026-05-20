import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import useAuth from '../hooks/useAuth'
import { login as loginService } from '../services/authService'
import { get } from '../services/api'
import '../styles/auth.css'

function Login() {
    const { login } = useAuth()
    const navigate = useNavigate()

    const [form, setForm] = useState({ email: '', password: '' })
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(false)

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)

        try {
            const respuesta = await loginService(form.email, form.password)
            localStorage.setItem('token', respuesta.token)

            const { get } = await import('../services/api')

            let usuarioCompleto

            if (respuesta.tipo === 'EMPLEADO') {
                const datos = await get(`/empleados/${respuesta.idUsuario}`)
                usuarioCompleto = {
                    id: respuesta.idUsuario,
                    nombre: datos.nombre,
                    apellidos: datos.apellidos,
                    email: datos.email,
                    telefono: datos.telefono,
                    rol: datos.rol,
                    tipo: 'EMPLEADO',
                    idEmpresa: respuesta.idEmpresa,
                    activo: datos.activo,
                }
            } else {
                const datos = await get(`/usuarios/${respuesta.idUsuario}`)
                usuarioCompleto = {
                    id: respuesta.idUsuario,
                    nombre: datos.nombre,
                    apellidos: datos.apellidos,
                    email: datos.email,
                    telefono: datos.telefono,
                    rol: datos.rol,
                    tipo: 'USUARIO',
                    idEmpresa: null,
                }
            }

            login(respuesta.token, usuarioCompleto)
            navigate('/home')
        } catch (err) {
            setError('Email o contraseña incorrectos')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="auth-wrapper">
            <div className="card auth-card" style={{ width: '100%', maxWidth: 420 }}>
                <div className="card-body p-4">

                    <h4 className="fw-bold mb-1 text-center">Bienvenido a ReservApp</h4>
                    <p className="text-muted text-center small mb-4">Inicia sesión en tu cuenta</p>

                    {error && (
                        <div className="alert alert-danger py-2 small">{error}</div>
                    )}

                    <form onSubmit={handleSubmit}>
                        <div className="mb-3">
                            <label className="form-label">Email</label>
                            <input
                                type="email"
                                name="email"
                                className="form-control"
                                value={form.email}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        <div className="mb-4">
                            <div className="d-flex justify-content-between align-items-center mb-1">
                                <label className="form-label mb-0">Contraseña</label>
                                <Link to="/forgot-password" className="small">
                                    ¿Olvidaste tu contraseña?
                                </Link>
                            </div>
                            <input
                                type="password"
                                name="password"
                                className="form-control"
                                value={form.password}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        <button className="btn btn-primary w-100" disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Entrando...</>
                                : 'Iniciar sesión'}
                        </button>
                    </form>

                    <p className="text-center small mt-3 mb-0">
                        ¿No tienes cuenta?{' '}
                        <Link to="/register">Regístrate</Link>
                    </p>

                </div>
            </div>
        </div>
    )
}

export default Login