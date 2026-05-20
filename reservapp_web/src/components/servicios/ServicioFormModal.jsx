import { useState, useEffect, useRef } from 'react'

const FORM_INICIAL = {
    nombre: '', descripcion: '', duracion: '', precio: '', capacidad: ''
}

function ServicioFormModal({ show, servicio, empresas, onGuardar, onCerrar }) {    
    const [form, setForm] = useState(FORM_INICIAL)
    const [idEmpresa, setIdEmpresa] = useState('')
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
        if (servicio) {
            setForm({
                nombre: servicio.nombre || '',
                descripcion: servicio.descripcion || '',
                duracion: servicio.duracion || '',
                precio: servicio.precio || '',
                capacidad: servicio.capacidad != null ? servicio.capacidad : '',
            })
            setIdEmpresa(servicio.idEmpresa || '')
        } else {
            setForm(FORM_INICIAL)
            setIdEmpresa(empresas?.length === 1 ? empresas[0].id : '')
        }
        setError(null)
    }, [servicio, show])
    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (!idEmpresa) { setError('Selecciona una empresa.'); return }
        setLoading(true)
        setError(null)
        try {
            await onGuardar({
                ...form,
                idEmpresa,
                duracion: Number(form.duracion),
                precio: Number(form.precio),
                capacidad: Number(form.capacidad)
            })
        } catch {
            setError('Error al guardar el servicio.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">
                            {servicio ? 'Editar servicio' : 'Nuevo servicio'}
                        </h5>
                        <button className="btn-close" onClick={onCerrar} disabled={loading} />
                    </div>

                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}

                        <form id="servicio-form" onSubmit={handleSubmit}>

                            {/* Selector de empresa solo si tiene más de una */}
                            {empresas.length > 1 && (
                                <div className="mb-3">
                                    <label className="form-label">Empresa</label>
                                    <select
                                        className="form-select"
                                        value={idEmpresa}
                                        onChange={(e) => setIdEmpresa(e.target.value)}
                                        required
                                    >
                                        <option value="">Selecciona empresa</option>
                                        {empresas.map((e) => (
                                            <option key={e.id} value={e.id}>{e.nombre}</option>
                                        ))}
                                    </select>
                                </div>
                            )}

                            <div className="row g-3">
                                <div className="col-12">
                                    <label className="form-label">Nombre del servicio</label>
                                    <input
                                        name="nombre"
                                        className="form-control"
                                        value={form.nombre}
                                        onChange={handleChange}
                                        required
                                        placeholder="Ej: Corte de cabello"
                                    />
                                </div>
                                <div className="col-12">
                                    <label className="form-label">Descripción <span className="text-muted">(opcional)</span></label>
                                    <textarea
                                        name="descripcion"
                                        className="form-control"
                                        rows={2}
                                        value={form.descripcion}
                                        onChange={handleChange}
                                    />
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Duración <span className="text-muted">(minutos)</span></label>
                                    <input
                                        type="number"
                                        name="duracion"
                                        className="form-control"
                                        value={form.duracion}
                                        onChange={handleChange}
                                        required
                                        min={1}
                                        placeholder="Ej: 30"
                                    />
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Precio <span className="text-muted">(€)</span></label>
                                    <input
                                        type="number"
                                        name="precio"
                                        className="form-control"
                                        value={form.precio}
                                        onChange={handleChange}
                                        required
                                        min={0}
                                        step="0.01"
                                        placeholder="Ej: 15.00"
                                    />
                                </div>
                                <div className="col-md-4">
                                    <label className="form-label">Capacidad <span className="text-muted">(personas)</span></label>
                                    <input
                                        type="number"
                                        name="capacidad"
                                        className="form-control"
                                        value={form.capacidad}
                                        onChange={handleChange}
                                        required min={1}
                                        placeholder="Ej: 5"
                                    />
                                </div>
                            </div>
                        </form>
                    </div>

                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={onCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-primary" type="submit" form="servicio-form" disabled={loading}>
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

export default ServicioFormModal