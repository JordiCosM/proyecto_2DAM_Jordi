import { useEffect, useRef } from 'react'

function ConfirmModal({ mensaje, onConfirmar, onCerrar, loading }) {
    const modalRef = useRef(null)
    const bsModal = useRef(null)

    useEffect(() => {
        if (modalRef.current && window.bootstrap) {
            bsModal.current = new window.bootstrap.Modal(modalRef.current, { backdrop: 'static' })
            bsModal.current.show()
        }
        return () => bsModal.current?.dispose()
    }, [])

    const handleCerrar = () => {
        bsModal.current?.hide()
        onCerrar()
    }

    return (
        <div className="modal fade" ref={modalRef} tabIndex={-1} aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered">
                <div className="modal-content">
                    <div className="modal-header border-0">
                        <h5 className="modal-title fw-semibold">¿Estás seguro?</h5>
                        <button className="btn-close" onClick={handleCerrar} disabled={loading} />
                    </div>
                    <div className="modal-body pt-0">{mensaje}</div>
                    <div className="modal-footer border-0">
                        <button className="btn btn-light" onClick={handleCerrar} disabled={loading}>Cancelar</button>
                        <button className="btn btn-danger" onClick={onConfirmar} disabled={loading}>
                            {loading
                                ? <><span className="spinner-border spinner-border-sm me-2" />Eliminando...</>
                                : <><i className="bi bi-trash me-2" />Eliminar</>}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default ConfirmModal