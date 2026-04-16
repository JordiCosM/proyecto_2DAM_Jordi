import { NavLink } from 'react-router-dom'
import useAuth from '../../hooks/useAuth'
import useEmpresa from '../../hooks/useEmpresa'
import {
  puedeVerDashboard,
  puedeVerEmpresas,
  puedeVerServiciosHorarios,
  puedeVerEmpleados,
  puedeVerApp,
} from '../../utils/permisos'
import '../../styles/sidebar.css'

function Sidebar({ isOpen, collapsed }) {
  const { usuario } = useAuth()
  const { tieneEmpresa } = useEmpresa()

  if (tieneEmpresa === null) return null

  const construirMenu = () => {
    if (!tieneEmpresa) return []

    const general = { label: 'General', items: [] }
    const gestion = { label: 'Gestión', items: [] }
    const cuenta = {
      label: 'Cuenta',
      items: usuario?.tipo === 'USUARIO'
        ? [{ to: '/perfil', icon: 'bi-person', label: 'Mi perfil' }]
        : []
    }

    if (puedeVerApp(usuario)) {
      general.items.push({ to: '/home', icon: 'bi-house', label: 'Inicio' })
      general.items.push({ to: '/reservas', icon: 'bi-calendar3', label: 'Reservas' })
    }

    if (puedeVerDashboard(usuario)) {
      general.items.push({ to: '/dashboard', icon: 'bi-bar-chart-line', label: 'Dashboard' })
    }

    if (puedeVerEmpresas(usuario)) {
      gestion.items.push({ to: '/empresas', icon: 'bi-building', label: 'Mis empresas' })
    }

    if (puedeVerServiciosHorarios(usuario)) {
      gestion.items.push({ to: '/servicios', icon: 'bi-grid', label: 'Servicios' })
      gestion.items.push({ to: '/horarios', icon: 'bi-clock', label: 'Horarios' })
    }

    if (puedeVerEmpleados(usuario)) {
      gestion.items.push({ to: '/empleados', icon: 'bi-people', label: 'Empleados' })
    }

    return [general, gestion, cuenta].filter((g) => g.items.length > 0)
  }

  const menu = construirMenu()

  const menuSinEmpresa = [
    { label: 'Cuenta', items: [{ to: '/perfil', icon: 'bi-person', label: 'Mi perfil' }] }
  ]

  const menuFinal = tieneEmpresa ? menu : menuSinEmpresa

  return (
    <>
      {isOpen && <div className="sidebar-overlay d-md-none" onClick={() => { }} />}
      <aside className={`sidebar ${isOpen ? 'sidebar-open' : ''} ${collapsed ? 'sidebar-collapsed' : ''}`}>
        <nav className="py-2">
          {menuFinal.map((grupo) => (
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