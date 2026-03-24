import { useState } from 'react'
import { Outlet } from 'react-router-dom'
import Navbar from './Navbar'
import Sidebar from './Sidebar'
import '../../styles/layout.css'

function Layout() {
    const [sidebarOpen, setSidebarOpen] = useState(false)
    const [sidebarCollapsed, setSidebarCollapsed] = useState(false)

    return (
        <>
            <Navbar
                onToggleSidebar={() => setSidebarOpen(!sidebarOpen)}
                onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
                collapsed={sidebarCollapsed}
            />
            <Sidebar isOpen={sidebarOpen} collapsed={sidebarCollapsed} />
            <main className={`layout-main ${sidebarCollapsed ? 'layout-collapsed' : ''}`}>
                <Outlet />
            </main>
        </>
    )
}

export default Layout