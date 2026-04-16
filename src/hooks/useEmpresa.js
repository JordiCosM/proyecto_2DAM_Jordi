import { useContext } from 'react'
import { EmpresaContext } from '../context/EmpresaContext'

function useEmpresas() {
    return useContext(EmpresaContext)
}

export default useEmpresas