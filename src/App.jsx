import { Routes, Route, Navigate } from 'react-router-dom'
import { useAuth } from './context/AuthContext'
import Layout from './components/layout/Layout'
import Login from './pages/Login'
import Register from './pages/Register'
import ForgotPassword from './pages/ForgotPassword'
import ResetPassword from './pages/ResetPassword'
import Home from './pages/Home'
import Empresas from './pages/Empresas'
import Servicios from './pages/Servicios'
import Horarios from './pages/Horarios'
import Reservas from './pages/Reservas'
import Perfil from './pages/Perfil'
import NotFound from './pages/NotFound'

function RutaProtegida({ children }) {
  const { token } = useAuth()
  return token ? children : <Navigate to="/login" replace />
}

function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/register" element={<Register />} />
      <Route path="/forgot-password" element={<ForgotPassword />} />
      <Route path="/reset-password" element={<ResetPassword />} />
      <Route element={<RutaProtegida><Layout /></RutaProtegida>}>
        <Route path="/home" element={<Home />} />
        <Route path="/empresas" element={<Empresas />} />
        <Route path="/servicios" element={<Servicios />} />
        <Route path="/horarios" element={<Horarios />} />
        <Route path="/reservas" element={<Reservas />} />
        <Route path="/perfil" element={<Perfil />} />
      </Route>
      <Route path="*" element={<NotFound />} />
    </Routes>
  )
}

export default App