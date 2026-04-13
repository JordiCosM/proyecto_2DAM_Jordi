import { useState, useEffect } from 'react'
import useAuth from '../hooks/useAuth'
import useEmpresas from '../hooks/useEmpresas'
import useDashboard from '../hooks/useDashboard'
import KpiCard from '../components/dashboard/KpiCard'
import GraficoReservasDia from '../components/dashboard/GraficoReservasDia'
import GraficoEstados from '../components/dashboard/GraficoEstados'
import GraficoServicios from '../components/dashboard/GraficoServicios'
import GraficoIngresos from '../components/dashboard/GraficoIngresos'
import SpinnerPage from '../components/common/SpinnerPage'
import EmptyState from '../components/common/EmptyState'
import EmpresaSelector from '../components/common/EmpresaSelector'
import '../styles/dashboard.css'
import '../styles/common.css'

function Dashboard() {
    const { usuario } = useAuth()
    const { data: empresas, loading: loadingEmpresas } = useEmpresas()
    const [empresaActiva, setEmpresaActiva] = useState(null)
    const { datos, loading, error } = useDashboard(empresaActiva)

    useEffect(() => {
        if (empresas?.length && !empresaActiva) setEmpresaActiva(empresas[0])
    }, [empresas])

    if (loadingEmpresas) {
        if (loadingEmpresas) return <SpinnerPage />
    }

    return (
        <>
            <div className="d-flex align-items-center justify-content-between mb-4">
                <h4 className="fw-bold mb-0">Dashboard</h4>
                {datos && !loading && (
                    <span className="text-muted small">
                        <i className="bi bi-calendar3 me-1" />
                        {new Date().toLocaleString('es-ES', { month: 'long', year: 'numeric' })}
                    </span>
                )}
            </div>

            <EmpresaSelector
                empresas={empresas}
                empresaActiva={empresaActiva}
                onSeleccionar={setEmpresaActiva}
            />

            {!empresaActiva ? (
                <EmptyState icono="bi-building" texto="Selecciona una empresa para ver su dashboard" />
            ) : loading ? (
                <SpinnerPage />
            ) : error ? (
                <div className="alert alert-danger">{error}</div>
            ) : datos && (
                <>
                    <div className="row g-3 mb-3">
                        <div className="col-12 col-xl-3">
                            <KpiCard
                                icono="bi-calendar-check"
                                color="#0d6efd"
                                fondo="#e7f1ff"
                                valor={datos.kpis.totalMes}
                                label="Reservas este mes"
                                sub={`${datos.kpis.pendientes} pendientes`}
                            />
                        </div>
                        <div className="col-12 col-xl-3">
                            <KpiCard
                                icono="bi-check-circle"
                                color="#198754"
                                fondo="#d1e7dd"
                                valor={datos.kpis.confirmadas}
                                label="Confirmadas este mes"
                                sub={`${datos.kpis.finalizadas} finalizadas`}
                                subColor="#198754"
                            />
                        </div>
                        <div className="col-12 col-xl-3">
                            <KpiCard
                                icono="bi-currency-euro"
                                color="#fd7e14"
                                fondo="#fff3cd"
                                valor={`${(datos.kpis.ingresoFinalizado + datos.kpis.ingresoConfirmado).toFixed(2)} €`}
                                label="Ingreso potencial mes"
                                sub={`${datos.kpis.ingresoFinalizado.toFixed(2)} € cobrados`}
                                subColor="#198754"
                            />
                        </div>
                        <div className="col-12 col-xl-3">
                            <KpiCard
                                icono="bi-star"
                                color="#6f42c1"
                                fondo="#e9d8fd"
                                valor={datos.kpis.servicioTop}
                                label="Servicio más popular"
                                sub={`${datos.kpis.canceladas} canceladas este mes`}
                                subColor="#dc3545"
                            />
                        </div>
                    </div>

                    <div className="row g-3 mb-3">
                        <div className="col-12 col-xl-8">
                            <GraficoReservasDia datos={datos.reservasPorDia} />
                        </div>
                        <div className="col-12 col-xl-4">
                            <GraficoEstados datos={datos.reservasPorEstado} />
                        </div>
                    </div>

                    <div className="row g-3">
                        <div className="col-12 col-xl-6">
                            <GraficoIngresos datos={datos.ingresosPorSemana} />
                        </div>
                        <div className="col-12 col-xl-6">
                            <GraficoServicios datos={datos.reservasPorServicio} />
                        </div>
                    </div>
                </>
            )}
        </>
    )
}

export default Dashboard