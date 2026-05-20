import { useEffect } from 'react'
import '../../styles/common.css'

function Toast({ mensaje, tipo = 'danger', onCerrar }) {
    useEffect(() => {
        const timer = setTimeout(onCerrar, 4000)
        return () => clearTimeout(timer)
    }, [])

    return (
        <div
            className={`toast-custom toast-${tipo}`}
            role="alert"
        >
            <div className="d-flex align-items-center gap-2">
                <i className={`bi ${tipo === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill'}`} />
                <span>{mensaje}</span>
            </div>
            <button className="toast-close" onClick={onCerrar}>
                <i className="bi bi-x" />
            </button>
        </div>
    )
}

export default Toast