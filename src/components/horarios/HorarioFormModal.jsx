import { useState, useEffect, useRef } from 'react'

const DIAS = ['LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO']

const FORM_INICIAL = { dia: 'LUNES', apertura: '', cierre: '' }

function HorarioFormModal({ horario, idEmpresa, onGuardar, onCerrar }) {
    const [form, setForm] = useState(FORM_INICIAL)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)
    const modalRef = useRef(null)
    const bsModal = useRef(null)

    useEffect(() => {
        if (modalRef.current && window.bootstrap) {
            bsModal.current = new window.bootstrap.Modal(modalRef.current, { backdrop: 'static' })
            bsModal.current.show()
        }
        return () => bsModal.current?.dispose()
    }, [])

    useEffect(() => {
        if (horario) {
            setForm({
                dia: horario.dia || 'LUNES',
                apertura: horario.apertura?.slice(0, 5) || '',
                cierre: horario.cierre?.slice(0, 5) || '',
            })
        } else {
            setForm(FORM_INICIAL)
        }
    }, [horario])

    const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value })

    const handleSubmit = async (e) => {
        e.preventDefault()
        if (form.apertura >= form.cierre) {
            setError('La hora de apertura debe ser anterior al cierre.')
            return
        }
        setLoading(true)
        setError(null)
        try {
            await onGuardar({
                ...form,
                idEmpresa,
                apertura: `${form.apertura}:00`,
                cierre: `${form.cierre}:00`,
            })
            bsModal.current?.hide()
        } catch {
            setError('Error al guardar el horario.')
        } finally {
            setLoading(false)
        }
    }

    const handleCerrar = () => {
        bsModal.current?.hide()
        onCerrar()
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content">
                    <div className="modal-header">
                        <h5 className="modal-title fw-semibold">
                            {horario ? 'Editar horario' : 'Nuevo horario'}
                        </h5>
                        <button className="btn-close" onClick={handleCerrar} disabled={loading} />
                    </div>

                    <div className="modal-body">
                        {error && <div className="alert alert-danger py-2 small">{error}</div>}

                        <form id="horario-form" onSubmit={handleSubmit}>
                            <div className="row g-3">
                                <div className="col-12">
                                    <label className="form-label">Día</label>
                                    <select
                                        name="dia"
                                        className="form-select"
                                        value={form.dia}
                                        onChange={handleChange}
                                        disabled={!!horario}
                                    >
                                        {DIAS.map((d) => (
                                            <option key={d} value={d}>{d.charAt(0) + d.slice(1).toLowerCase()}</option>
                                        ))}
                                    </select>
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Apertura</label>
                                    <input
                                        type="time"
                                        name="apertura"
                                        className="form-control"
                                        value={form.apertura}
                                        onChange={handleChange}
                                        required
                                    />
                                </div>
                                <div className="col-md-6">
                                    <label className="form-label">Cierre</label>
                                    <input
                                        type="time"
                                        name="cierre"
                                        className="form-control"
                                        value={form.cierre}
                                        onChange={handleChange}
                                        required
                                    />
                                </div>
                            </div>
                        </form>
                    </div>

                    <div className="modal-footer">
                        <button className="btn btn-light" onClick={handleCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-primary" type="submit" form="horario-form" disabled={loading}>
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

export default HorarioFormModal