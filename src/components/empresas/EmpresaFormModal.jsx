import { useState, useEffect, useRef } from 'react'
import { getProvincias, getCiudadesByProvincia } from '../../services/ubicacionService'

const FORM_INICIAL = {
    nombre: '', descripcion: '', direccion: '',
    telefono: '', email: '', sector: '', logoUrl: '', idCiudad: ''
}

function EmpresaFormModal({ show, empresa, onGuardar, onCerrar }) {
    const [form, setForm] = useState(FORM_INICIAL)
    const [provincias, setProvincias] = useState([])
    const [ciudades, setCiudades] = useState([])
    const [idProvincia, setIdProvincia] = useState('')
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)
    const modalRef = useRef(null)
    const bsModal = useRef(null)

    useEffect(() => {
        if (!modalRef.current || !window.bootstrap) return
        bsModal.current = new window.bootstrap.Modal(modalRef.current, { backdrop: 'static' })
        return () => { bsModal.current?.dispose(); bsModal.current = null }
    }, [])

    useEffect(() => {
        if (!bsModal.current) return
        show ? bsModal.current.show() : bsModal.current.hide()
    }, [show])

    useEffect(() => {
        if (show) getProvincias().then(setProvincias)
    }, [show])

    useEffect(() => {
        if (empresa) {
            setForm({
                nombre: empresa.nombre || '',
                descripcion: empresa.descripcion || '',
                direccion: empresa.direccion || '',
                telefono: empresa.telefono || '',
                email: empresa.email || '',
                sector: empresa.sector || '',
                logoUrl: empresa.logoUrl || '',
                idCiudad: empresa.idCiudad || '',
            })
        } else {
            setForm(FORM_INICIAL)
            setIdProvincia('')
        }
        setError(null)
    }, [empresa, show])

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
            await onGuardar(form)
        } catch {
            setError('Error al guardar la empresa.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered modal-lg">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">{empresa ? 'Editar empresa' : 'Nueva empresa'}</h5>
                        <button className="btn-close" onClick={onCerrar} disabled={loading} />
                    </div>
                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}
                        <form id="empresa-form" onSubmit={handleSubmit}>
                            <div className="row g-3">
                                <div className="col-12">
                                    <label className="form-label">Nombre</label>
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
                                    >
                                        <option value="">Selecciona provincia</option>
                                        {provincias.map((p) => <option key={p.id} value={p.id}>{p.nombre}</option>)}
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
                                    >
                                        <option value="">Selecciona ciudad</option>
                                        {ciudades.map((c) => <option key={c.id} value={c.id}>{c.nombre}</option>)}
                                    </select>
                                </div>
                                <div className="col-12">
                                    <label className="form-label">URL del logo <span className="text-muted">(opcional)</span></label>
                                    <input name="logoUrl" className="form-control" value={form.logoUrl} onChange={handleChange} placeholder="https://..." />
                                </div>
                            </div>
                        </form>
                    </div>
                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={onCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-primary" type="submit" form="empresa-form" disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Guardando...</>
                                : <><i className="bi bi-check-lg me-2" />Guardar</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default EmpresaFormModal