import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { useEmpresa } from '../context/EmpresaContext'
import { updateUsuario, deleteUsuario } from '../services/usuarioService'
import useToast from '../hooks/useToast'
import PerfilCabecera from '../components/perfil/PerfilCabecera'
import PerfilForm from '../components/perfil/PerfilForm'
import DangerZone from '../components/perfil/DangerZone'
import ConfirmModal from '../components/common/ConfirmModal'
import Toast from '../components/common/Toast'
import '../styles/perfil.css'

function Perfil() {
    const { usuario, login, logout } = useAuth()
    const { setTieneEmpresa } = useEmpresa()
    const navigate = useNavigate()
    const { toast, mostrarError, mostrarExito, cerrarToast } = useToast()

    const [form, setForm] = useState({
        nombre: '', apellidos: '', email: '', telefono: ''
    })
    const [loading, setLoading] = useState(false)
    const [exito, setExito] = useState(false)
    const [error, setError] = useState(null)
    const [modalBorrar, setModalBorrar] = useState(false)
    const [loadingDelete, setLoadingDelete] = useState(false)

    useEffect(() => {
        if (usuario) {
            setForm({
                nombre: usuario.nombre || '',
                apellidos: usuario.apellidos || '',
                email: usuario.email || '',
                telefono: usuario.telefono || '',
            })
        }
    }, [usuario])

    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value })
        setExito(false)
        setError(null)
    }

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)
        setExito(false)
        try {
            const actualizado = await updateUsuario(usuario.id, { ...form, rol: usuario.rol })
            login(localStorage.getItem('token'), { ...usuario, ...actualizado })
            setExito(true)
            mostrarExito('Perfil actualizado correctamente')
        } catch {
            setError('Error al guardar los cambios.')
            mostrarError('Error al guardar los cambios.')
        } finally {
            setLoading(false)
        }
    }

    const handleEliminarCuenta = async () => {
        setLoadingDelete(true)
        try {
            await deleteUsuario(usuario.id)
            logout()
            setTieneEmpresa(null)
            navigate('/login')
        } catch {
            mostrarError('Error al eliminar la cuenta.')
        } finally {
            setLoadingDelete(false)
        }
    }

    return (
        <>
            <h4 className="fw-bold mb-4">Mi perfil</h4>

            <div className="card perfil-card mb-4">
                <div className="card-body">
                    <PerfilCabecera usuario={usuario} />
                    <div className="perfil-seccion-titulo">Datos personales</div>
                    <PerfilForm
                        form={form}
                        onChange={handleChange}
                        onSubmit={handleSubmit}
                        loading={loading}
                        exito={exito}
                        error={error}
                    />
                </div>
            </div>

            <DangerZone onEliminar={() => setModalBorrar(true)} />

            {modalBorrar && (
                <ConfirmModal
                    mensaje="¿Seguro que quieres eliminar tu cuenta? Perderás todos tus datos, empresas y reservas. Esta acción no se puede deshacer."
                    onConfirmar={handleEliminarCuenta}
                    onCerrar={() => setModalBorrar(false)}
                    loading={loadingDelete}
                />
            )}

            {toast && <Toast mensaje={toast.mensaje} tipo={toast.tipo} onCerrar={cerrarToast} />}
        </>
    )
}

export default Perfil