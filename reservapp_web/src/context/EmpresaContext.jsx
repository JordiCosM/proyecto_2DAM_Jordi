import { createContext, useState, useEffect, useContext } from 'react'
import { AuthContext } from './AuthContext'
import { getEmpresasByUsuario } from '../services/empresaService'

export const EmpresaContext = createContext(null)

export function EmpresaProvider({ children }) {
    const { usuario, token } = useContext(AuthContext)
    const [tieneEmpresa, setTieneEmpresa] = useState(null)

    useEffect(() => {
        if (!token || !usuario) { setTieneEmpresa(null); return }
        if (usuario.tipo === 'EMPLEADO') { setTieneEmpresa(true); return }
        if (usuario.rol === 'CLIENTE') { setTieneEmpresa(false); return }
        getEmpresasByUsuario(usuario.id)
            .then((e) => setTieneEmpresa(e && e.length > 0))
            .catch(() => setTieneEmpresa(false))
    }, [token, usuario?.id, usuario?.tipo])

    return (
        <EmpresaContext.Provider value={{ tieneEmpresa, setTieneEmpresa }}>
            {children}
        </EmpresaContext.Provider>
    )
}