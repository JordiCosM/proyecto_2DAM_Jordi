import { useState } from 'react'

function useToast() {
    const [toast, setToast] = useState(null)

    const mostrarError = (mensaje) => setToast({ mensaje, tipo: 'danger' })
    const mostrarExito = (mensaje) => setToast({ mensaje, tipo: 'success' })
    const cerrarToast = () => setToast(null)

    return { toast, mostrarError, mostrarExito, cerrarToast }
}

export default useToast