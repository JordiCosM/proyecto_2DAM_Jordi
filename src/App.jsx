import { Routes, Route, Navigate } from 'react-router-dom'
import useAuth from './hooks/useAuth'
import { puedeVerApp, puedeVerDashboard, puedeVerEmpresas, puedeVerServiciosHorarios, puedeVerEmpleados, puedeVerPerfil } from './utils/permisos'
import Layout from './components/layout/Layout'
import Login from './pages/Login'
import Register from './pages/Register'
import ForgotPassword from './pages/ForgotPassword'
import ResetPassword from './pages/ResetPassword'
import Home from './pages/Home'
import Dashboard from './pages/Dashboard'
import Empresas from './pages/Empresas'
import Servicios from './pages/Servicios'
import Horarios from './pages/Horarios'
import Reservas from './pages/Reservas'
import Empleados from './pages/Empleados'
import Perfil from './pages/Perfil'
import NotFound from './pages/NotFound'

function RutaProtegida({ children, permitido = true }) {
  const { token } = useAuth()
  if (!token) return <Navigate to="/login" replace />
  if (!permitido) return <Navigate to="/home" replace />
  return children
}

function App() {
  const { usuario } = useAuth()

  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />
      <Route path="/forgot-password" element={<ForgotPassword />} />
      <Route path="/reset-password" element={<ResetPassword />} />

      <Route element={<RutaProtegida><Layout /></RutaProtegida>}>
        <Route path="/home" element={<RutaProtegida permitido={puedeVerApp(usuario)}><Home /></RutaProtegida>} />
        <Route path="/reservas" element={<RutaProtegida permitido={puedeVerApp(usuario)}><Reservas /></RutaProtegida>} />
        <Route path="/dashboard" element={<RutaProtegida permitido={puedeVerDashboard(usuario)}><Dashboard /></RutaProtegida>} />
        <Route path="/empresas" element={<RutaProtegida permitido={puedeVerEmpresas(usuario)}><Empresas /></RutaProtegida>} />
        <Route path="/servicios" element={<RutaProtegida permitido={puedeVerServiciosHorarios(usuario)}><Servicios /></RutaProtegida>} />
        <Route path="/horarios" element={<RutaProtegida permitido={puedeVerServiciosHorarios(usuario)}><Horarios /></RutaProtegida>} />
        <Route path="/empleados" element={<RutaProtegida permitido={puedeVerEmpleados(usuario)}><Empleados /></RutaProtegida>} />
        <Route path="/perfil" element={<RutaProtegida permitido={puedeVerPerfil(usuario)}><Perfil /></RutaProtegida>} />
      </Route>

      <Route path="/" element={<Navigate to="/home" replace />} />
      <Route path="*" element={<NotFound />} />
    </Routes>
  )
}

export default App