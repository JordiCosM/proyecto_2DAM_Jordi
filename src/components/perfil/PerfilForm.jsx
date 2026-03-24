function PerfilForm({ form, onChange, onSubmit, loading, exito, error }) {
    return (
        <>
            {exito && (
                <div className="alert alert-success py-2 small d-flex align-items-center gap-2">
                    <i className="bi bi-check-circle-fill" />
                    Cambios guardados correctamente
                </div>
            )}
            {error && (
                <div className="alert alert-danger py-2 small">{error}</div>
            )}

            <form onSubmit={onSubmit}>
                <div className="row g-3">
                    <div className="col-md-6">
                        <label className="form-label">Nombre</label>
                        <input
                            name="nombre"
                            className="form-control"
                            value={form.nombre}
                            onChange={onChange}
                            required
                        />
                    </div>
                    <div className="col-md-6">
                        <label className="form-label">Apellidos</label>
                        <input
                            name="apellidos"
                            className="form-control"
                            value={form.apellidos}
                            onChange={onChange}
                            required
                        />
                    </div>
                    <div className="col-md-6">
                        <label className="form-label">Email</label>
                        <input
                            type="email"
                            name="email"
                            className="form-control"
                            value={form.email}
                            onChange={onChange}
                            required
                        />
                    </div>
                    <div className="col-md-6">
                        <label className="form-label">Teléfono</label>
                        <input
                            name="telefono"
                            className="form-control"
                            value={form.telefono}
                            onChange={onChange}
                            required
                        />
                    </div>
                </div>

                <div className="d-flex justify-content-end mt-4">
                    <button className="btn btn-primary" disabled={loading}>
                        {loading
                            ? <><span className="spinner-border spinner-border-sm me-2" />Guardando...</>
                            : <><i className="bi bi-check-lg me-2" />Guardar cambios</>}
                    </button>
                </div>
            </form>
        </>
    )
}

export default PerfilForm