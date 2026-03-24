import { createContext, useContext, useState, useEffect } from 'react'
import { useAuth } from './AuthContext'
import { getEmpresasByUsuario } from '../services/empresaService'

const EmpresaContext = createContext(null)

export function EmpresaProvider({ children }) {
    const { usuario, token } = useAuth()
    const [tieneEmpresa, setTieneEmpresa] = useState(null)

    useEffect(() => {
        if (!token || !usuario) {
            setTieneEmpresa(null)
            return
        }
        getEmpresasByUsuario(usuario.id)
            .then((empresas) => setTieneEmpresa(empresas && empresas.length > 0))
            .catch(() => setTieneEmpresa(false))
    }, [token, usuario?.id])

    return (
        <EmpresaContext.Provider value={{ tieneEmpresa, setTieneEmpresa }}>
            {children}
        </EmpresaContext.Provider>
    )
}

export function useEmpresa() {
    return useContext(EmpresaContext)
}