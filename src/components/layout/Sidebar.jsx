import { NavLink } from 'react-router-dom'
import { useEmpresa } from '../../context/EmpresaContext'
import '../../styles/sidebar.css'

const menu = [
  {
    label: 'General',
    items: [
      { to: '/home', icon: 'bi-house', label: 'Inicio' },
      { to: '/reservas', icon: 'bi-calendar3', label: 'Reservas' },
    ],
  },
  {
    label: 'Gestión',
    items: [
      { to: '/empresas', icon: 'bi-building', label: 'Mis empresas' },
      { to: '/servicios', icon: 'bi-grid', label: 'Servicios' },
      { to: '/horarios', icon: 'bi-clock', label: 'Horarios' },
    ],
  },
  {
    label: 'Cuenta',
    items: [
      { to: '/perfil', icon: 'bi-person', label: 'Mi perfil' },
    ],
  },
]

function Sidebar({ isOpen, collapsed }) {
  const { tieneEmpresa } = useEmpresa()

  if (tieneEmpresa === null) return null

  const menuFiltrado = tieneEmpresa
    ? menu
    : menu.filter((g) => g.label === 'Cuenta')

  return (
    <>
      {isOpen && <div className="sidebar-overlay d-md-none" />}

      <aside className={`sidebar ${isOpen ? 'sidebar-open' : ''} ${collapsed ? 'sidebar-collapsed' : ''}`}>
        <nav className="py-2">
          {menuFiltrado.map((grupo) => (
            <div key={grupo.label}>
              <div className="sidebar-section-label">{grupo.label}</div>
              {grupo.items.map((item) => (
                <NavLink
                  key={item.to}
                  to={item.to}
                  className={({ isActive }) => `sidebar-link ${isActive ? 'active' : ''}`}
                  title={collapsed ? item.label : ''}
                >
                  <i className={`bi ${item.icon}`} />
                  <span className="sidebar-link-label">{item.label}</span>
                </NavLink>
              ))}
            </div>
          ))}
        </nav>
      </aside>
    </>
  )
}

export default Sidebar