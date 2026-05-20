import { useState, useEffect } from 'react'
import { getProvincias, getCiudadesByProvincia } from '../../services/ubicacionService'
import { createEmpresa } from '../../services/empresaService'
import { useAuth } from '../../context/AuthContext'
import '../../styles/home.css'

const FORM_INICIAL = {
    nombre: '', descripcion: '', direccion: '',
    telefono: '', email: '', sector: '', logoUrl: '', idCiudad: ''
}

function CrearEmpresaForm({ onEmpresaCreada }) {
    const { usuario } = useAuth()

    const [form, setForm] = useState(FORM_INICIAL)
    const [provincias, setProvincias] = useState([])
    const [ciudades, setCiudades] = useState([])
    const [idProvincia, setIdProvincia] = useState('')
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    useEffect(() => {
        getProvincias().then(setProvincias)
    }, [])

    useEffect(() => {
        if (!idProvincia) { setCiudades([]); return }
        getCiudadesByProvincia(idProvincia).then(setCiudades)
    }, [idProvincia])

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        try {
            const nueva = await createEmpresa({ ...form, idUsuario: usuario.id })
            onEmpresaCreada(nueva)
        } catch (err) {
            setError('Error al crear la empresa. Revisa los datos.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="crear-empresa-card card">
            <div className="card-body p-4">
                <div className="text-center mb-4">
                    <i className="bi bi-building-add text-primary" style={{ fontSize: '2.5rem' }} />
                    <h5 className="fw-bold mt-2 mb-1">Crea tu primera empresa</h5>
                    <p className="text-muted small">Rellena los datos para empezar a gestionar reservas</p>
                </div>

                {error && <div className="alert alert-danger py-2 small">{error}</div>}

                <form onSubmit={handleSubmit}>
                    <div className="row g-3">
                        <div className="col-12">
                            <label className="form-label">Nombre de la empresa</label>
                            <input name="nombre" className="form-control" value={form.nombre} onChange={handleChange} required />
                        </div>
                        <div className="col-12">
                            <label className="form-label">Descripción</label>
                            <textarea name="descripcion" className="form-control" rows={2} value={form.descripcion} onChange={handleChange} />
                        </div>
                        <div className="col-md-6">
                            <label className="form-label">Sector</label>
                            <input name="sector" className="form-control" value={form.sector} onChange={handleChange} placeholder="Ej: Peluquería, Clínica..." />
                        </div>
                        <div className="col-md-6">
                            <label className="form-label">Teléfono</label>
                            <input name="telefono" className="form-control" value={form.telefono} onChange={handleChange} required />
                        </div>
                        <div className="col-12">
                            <label className="form-label">Email de contacto</label>
                            <input type="email" name="email" className="form-control" value={form.email} onChange={handleChange} required />
                        </div>
                        <div className="col-12">
                            <label className="form-label">Dirección</label>
                            <input name="direccion" className="form-control" value={form.direccion} onChange={handleChange} required />
                        </div>
                        <div className="col-md-6">
                            <label className="form-label">Provincia</label>
                            <select
                                className="form-select"
                                value={idProvincia}
                                onChange={(e) => { setIdProvincia(e.target.value); setForm({ ...form, idCiudad: '' }) }}
                                required
                            >
                                <option value="">Selecciona provincia</option>
                                {provincias.map((p) => (
                                    <option key={p.id} value={p.id}>{p.nombre}</option>
                                ))}
                            </select>
                        </div>
                        <div className="col-md-6">
                            <label className="form-label">Ciudad</label>
                            <select
                                className="form-select"
                                name="idCiudad"
                                value={form.idCiudad}
                                onChange={handleChange}
                                disabled={!idProvincia}
                                required
                            >
                                <option value="">Selecciona ciudad</option>
                                {ciudades.map((c) => (
                                    <option key={c.id} value={c.id}>{c.nombre}</option>
                                ))}
                            </select>
                        </div>
                        <div className="col-12">
                            <label className="form-label">URL del logo <span className="text-muted">(opcional)</span></label>
                            <input name="logoUrl" className="form-control" value={form.logoUrl} onChange={handleChange} placeholder="https://..." />
                        </div>
                    </div>

                    <button className="btn btn-primary w-100 mt-4" disabled={loading}>
                        {loading
                            ? <><span className="spinner-border spinner-border-sm me-2" />Creando empresa...</>
                            : <><i className="bi bi-check-lg me-2" />Crear empresa</>}
                    </button>
                </form>
            </div>
        </div>
    )
}

export default CrearEmpresaForm