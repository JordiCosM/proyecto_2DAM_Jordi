import { useCallback } from 'react'
import useAuth from './useAuth'
import { getEmpresasByUsuario, getEmpresa } from '../services/empresaService'
import useFetch from './useFetch'

function useEmpresas() {
    const { usuario } = useAuth()

    const fetchFn = useCallback(() => {
        if (!usuario) return Promise.resolve([])
        if (usuario.tipo === 'EMPLEADO') {
            return getEmpresa(usuario.idEmpresa).then((e) => [e])
        }
        return getEmpresasByUsuario(usuario.id)
    }, [usuario?.id, usuario?.tipo, usuario?.idEmpresa])

    return useFetch(fetchFn, [usuario?.id])
}

export default useEmpresas