import { useState, useEffect, useRef } from 'react'
import { getProvincias, getCiudadesByProvincia } from '../../services/ubicacionService'
import { subirLogo, subirImagen, eliminarImagen } from '../../services/empresaService'
import { IMG_BASE_URL } from '../../services/api'

const FORM_INICIAL = {
    nombre: '', descripcion: '', direccion: '',
    telefono: '', email: '', sector: '', idCiudad: ''
}

function EmpresaFormModal({ show, empresa, onGuardar, onCerrar }) {
    const [form, setForm] = useState(FORM_INICIAL)
    const [provincias, setProvincias] = useState([])
    const [ciudades, setCiudades] = useState([])
    const [idProvincia, setIdProvincia] = useState('')
    const [loading, setLoading] = useState(false)
    const [uploadingLogo, setUploadingLogo] = useState(false)
    const [uploadingImg, setUploadingImg] = useState(false)
    const [logoUrl, setLogoUrl] = useState('')
    const [imagenes, setImagenes] = useState([])
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
                idCiudad: empresa.idCiudad || '',
            })
            setLogoUrl(empresa.logoUrl || '')
            setImagenes(empresa.imagenes || [])
        } else {
            setForm(FORM_INICIAL)
            setIdProvincia('')
            setLogoUrl('')
            setImagenes([])
        }
        setError(null)
    }, [empresa, show])

    useEffect(() => {
        if (!idProvincia) { setCiudades([]); return }
        getCiudadesByProvincia(idProvincia).then(setCiudades)
    }, [idProvincia])

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleLogoChange = async (e) => {
        const file = e.target.files[0]
        if (!file || !empresa?.id) return
        setUploadingLogo(true)
        setError(null)
        try {
            const data = await subirLogo(empresa.id, file)
            setLogoUrl(data.logoUrl)
        } catch {
            setError('Error al subir el logo.')
        } finally {
            setUploadingLogo(false)
            e.target.value = ''
        }
    }

    const handleImagenChange = async (e) => {
        const file = e.target.files[0]
        if (!file || !empresa?.id) return
        setUploadingImg(true)
        setError(null)
        try {
            const data = await subirImagen(empresa.id, file)
            setImagenes(data.imagenes || [])
        } catch {
            setError('Error al subir la imagen.')
        } finally {
            setUploadingImg(false)
            e.target.value = ''
        }
    }

    const handleEliminarImagen = async (url) => {
        if (!empresa?.id) return
        setError(null)
        try {
            const data = await eliminarImagen(empresa.id, url)
            setImagenes(data.imagenes || [])
        } catch {
            setError('Error al eliminar la imagen.')
        }
    }

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

    const esNueva = !empresa?.id
    const imgUrl = (ruta) => ruta ? `${IMG_BASE_URL}${ruta}` : null

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered modal-lg">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">
                            {empresa ? 'Editar empresa' : 'Nueva empresa'}
                        </h5>
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
                                    <select className="form-select" value={idProvincia}
                                        onChange={(e) => { setIdProvincia(e.target.value); setForm({ ...form, idCiudad: '' }) }}>
                                        <option value="">Selecciona provincia</option>
                                        {provincias.map(p => <option key={p.id} value={p.id}>{p.nombre}</option>)}
                                    </select>
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Ciudad</label>
                                    <select className="form-select" name="idCiudad" value={form.idCiudad}
                                        onChange={handleChange} disabled={!idProvincia}>
                                        <option value="">Selecciona ciudad</option>
                                        {ciudades.map(c => <option key={c.id} value={c.id}>{c.nombre}</option>)}
                                    </select>
                                </div>

                                {/* Logo */}
                                <div className="col-12">
                                    <label className="form-label">Logo de la empresa</label>
                                    <div className="d-flex align-items-center gap-3">
                                        {logoUrl
                                            ? <img src={imgUrl(logoUrl)} alt="Logo" className="rounded border"
                                                style={{ width: 72, height: 72, objectFit: 'cover' }} />
                                            : <div className="rounded border bg-light d-flex align-items-center justify-content-center"
                                                style={{ width: 72, height: 72 }}>
                                                <i className="bi bi-building text-muted fs-4" />
                                            </div>
                                        }
                                        <div>
                                            <label className={`btn btn-outline-secondary btn-sm ${(esNueva || uploadingLogo) ? 'disabled' : ''}`}>
                                                {uploadingLogo
                                                    ? <><span className="spinner-border spinner-border-sm me-1" />Subiendo...</>
                                                    : <><i className="bi bi-upload me-1" />Subir logo</>}
                                                <input type="file" accept="image/*" className="d-none"
                                                    onChange={handleLogoChange} disabled={esNueva || uploadingLogo} />
                                            </label>
                                            {esNueva && (
                                                <p className="text-muted small mb-0 mt-1">
                                                    Guarda la empresa primero para subir imágenes.
                                                </p>
                                            )}
                                        </div>
                                    </div>
                                </div>

                                {/* Galería */}
                                {!esNueva && (
                                    <div className="col-12">
                                        <label className="form-label">Imágenes del negocio</label>
                                        <div className="d-flex flex-wrap gap-2 mb-2">
                                            {imagenes.map((url) => (
                                                <div key={url} className="position-relative">
                                                    <img src={imgUrl(url)} alt="Negocio" className="rounded border"
                                                        style={{ width: 90, height: 90, objectFit: 'cover' }} />
                                                    <button type="button"
                                                        className="btn btn-danger btn-sm position-absolute top-0 end-0 p-0"
                                                        style={{ width: 22, height: 22, lineHeight: 1 }}
                                                        onClick={() => handleEliminarImagen(url)}>
                                                        <i className="bi bi-x" />
                                                    </button>
                                                </div>
                                            ))}
                                            <label className="rounded border bg-light d-flex flex-column align-items-center justify-content-center"
                                                style={{ width: 90, height: 90, cursor: uploadingImg ? 'default' : 'pointer' }}>
                                                {uploadingImg
                                                    ? <span className="spinner-border spinner-border-sm" />
                                                    : <>
                                                        <i className="bi bi-plus-lg text-muted fs-5" />
                                                        <span className="text-muted" style={{ fontSize: 11 }}>Añadir</span>
                                                    </>
                                                }
                                                <input type="file" accept="image/*" className="d-none"
                                                    onChange={handleImagenChange} disabled={uploadingImg} />
                                            </label>
                                        </div>
                                        <p className="text-muted small mb-0">
                                            Muestra el interior, el equipo o el ambiente del negocio.
                                        </p>
                                    </div>
                                )}
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