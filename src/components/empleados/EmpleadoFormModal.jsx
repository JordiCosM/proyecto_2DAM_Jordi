import { useState, useEffect, useRef } from 'react'

const ROLES = ['BASICO', 'SUPERVISOR', 'ADMIN_EMPRESA']
const FORM_INICIAL = { nombre: '', apellidos: '', email: '', password: '', telefono: '', rol: 'BASICO' }

function EmpleadoFormModal({ show, empleado, idEmpresa, onGuardar, onCerrar }) {
    const [form, setForm] = useState(FORM_INICIAL)
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
        if (empleado) {
            setForm({
                nombre: empleado.nombre || '',
                apellidos: empleado.apellidos || '',
                email: empleado.email || '',
                password: '',
                telefono: empleado.telefono || '',
                rol: empleado.rol || 'BASICO',
            })
        } else {
            setForm(FORM_INICIAL)
        }
        setError(null)
    }, [empleado, show])

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        try {
            const datos = empleado
                ? { nombre: form.nombre, apellidos: form.apellidos, email: form.email, telefono: form.telefono, rol: form.rol, idEmpresa }
                : { ...form, idEmpresa }
            await onGuardar(datos)
        } catch {
            setError('Error al guardar el empleado.')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">{empleado ? 'Editar empleado' : 'Nuevo empleado'}</h5>
                        <button className="btn-close" onClick={onCerrar} disabled={loading} />
                    </div>
                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}
                        <form id="empleado-form" onSubmit={handleSubmit}>
                            <div className="row g-3">
                                <div className="col-md-6">
                                    <label className="form-label">Nombre</label>
                                    <input name="nombre" className="form-control" value={form.nombre} onChange={handleChange} required />
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Apellidos</label>
                                    <input name="apellidos" className="form-control" value={form.apellidos} onChange={handleChange} required />
                                </div>
                                <div className="col-12">
                                    <label className="form-label">Email</label>
                                    <input type="email" name="email" className="form-control" value={form.email} onChange={handleChange} required />
                                </div>
                                {!empleado && (
                                    <div className="col-12">
                                        <label className="form-label">Contraseña</label>
                                        <input type="password" name="password" className="form-control" value={form.password} onChange={handleChange} required minLength={8} />
                                    </div>
                                )}
                                <div className="col-md-6">
                                    <label className="form-label">Teléfono</label>
                                    <input name="telefono" className="form-control" value={form.telefono} onChange={handleChange} />
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Rol</label>
                                    <select name="rol" className="form-select" value={form.rol} onChange={handleChange}>
                                        {ROLES.map((r) => (
                                            <option key={r} value={r}>{r.charAt(0) + r.slice(1).toLowerCase().replace('_', ' ')}</option>
                                        ))}
                                    </select>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={onCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-primary" type="submit" form="empleado-form" disabled={loading}>
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

export default EmpleadoFormModal