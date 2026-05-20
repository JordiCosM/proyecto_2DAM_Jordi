import { useState, useEffect, useCallback } from 'react'

function useFetch(fetchFn, deps = []) {
    const [data, setData] = useState(null)
    const [loading, setLoading] = useState(true)
    const [error, setError] = useState(null)

    const ejecutar = useCallback(async () => {
        setLoading(true)
        setError(null)
        try {
            const resultado = await fetchFn()
            setData(resultado || [])
        } catch (err) {
            setError(err.message || 'Error al cargar los datos.')
        } finally {
            setLoading(false)
        }
    }, deps)

    useEffect(() => {
        ejecutar()
    }, [ejecutar])

    return { data, loading, error, refetch: ejecutar }
}

export default useFetch