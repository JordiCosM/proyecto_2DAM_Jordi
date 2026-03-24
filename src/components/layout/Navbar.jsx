import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import { useEmpresa } from '../../context/EmpresaContext'
import '../../styles/navbar.css'

function Navbar({ onToggleSidebar, onToggleCollapse, collapsed }) {
    const { usuario, logout } = useAuth()
    const { setTieneEmpresa } = useEmpresa()
    const navigate = useNavigate()

    const handleLogout = () => {
        logout()
        setTieneEmpresa(null)
        navigate('/login')
    }

    return (
        <nav className="navbar navbar-dark bg-dark fixed-top px-3" style={{ height: 56, zIndex: 1030 }}>
            <div className="d-flex align-items-center gap-2">
                <button className="btn btn-outline-secondary btn-sm d-md-none" onClick={onToggleSidebar}>
                    <i className="bi bi-list fs-5" />
                </button>
                <button className="btn btn-outline-secondary btn-sm d-none d-md-inline-flex align-items-center" onClick={onToggleCollapse}>
                    <i className={`bi ${collapsed ? 'bi-layout-sidebar' : 'bi-layout-sidebar-inset'}`} />
                </button>
                <span className="navbar-brand mb-0 navbar-brand-text ms-1">
                    <i className="bi bi-calendar-check me-2 text-primary" />
                    ReservApp
                </span>
            </div>

            <div className="dropdown">
                <button
                    className="btn btn-outline-secondary btn-sm dropdown-toggle navbar-user-btn"
                    data-bs-toggle="dropdown"
                >
                    <i className="bi bi-person-circle" />
                    <span className="d-none d-sm-inline">{usuario?.nombre}</span>
                </button>
                <ul className="dropdown-menu dropdown-menu-end">
                    <li>
                        <span className="dropdown-item-text small text-muted">{usuario?.email}</span>
                    </li>
                    <li><hr className="dropdown-divider" /></li>
                    <li>
                        <button className="dropdown-item" onClick={() => navigate('/perfil')}>
                            <i className="bi bi-person me-2" />Mi perfil
                        </button>
                    </li>
                    <li>
                        <button className="dropdown-item text-danger" onClick={handleLogout}>
                            <i className="bi bi-box-arrow-right me-2" />Cerrar sesión
                        </button>
                    </li>
                </ul>
            </div>
        </nav>
    )
}

export default Navbar