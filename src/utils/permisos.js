export function esCreador(usuario) {
    return usuario?.tipo === 'USUARIO' && usuario?.rol === 'EMPRESA'
}

export function esAdminEmpresa(usuario) {
    return usuario?.tipo === 'EMPLEADO' && usuario?.rol === 'ADMIN_EMPRESA'
}

export function esSupervisor(usuario) {
    return usuario?.tipo === 'EMPLEADO' && usuario?.rol === 'SUPERVISOR'
}

export function esBasico(usuario) {
    return usuario?.tipo === 'EMPLEADO' && usuario?.rol === 'BASICO'
}

export function esCliente(usuario) {
    return usuario?.tipo === 'USUARIO' && usuario?.rol === 'CLIENTE'
}

export function puedeVerApp(usuario) {
    return esCreador(usuario) || usuario?.tipo === 'EMPLEADO'
}

export function puedeVerDashboard(usuario) {
    return esCreador(usuario) || esAdminEmpresa(usuario)
}

export function puedeVerEmpresas(usuario) {
    return esCreador(usuario)
}

export function puedeVerServiciosHorarios(usuario) {
    return esCreador(usuario) || esAdminEmpresa(usuario) || esSupervisor(usuario)
}

export function puedeEditar(usuario) {
    return esCreador(usuario) || esAdminEmpresa(usuario)
}

export function puedeVerPerfil(usuario) {
    return usuario?.tipo === 'USUARIO' && usuario?.rol === 'EMPRESA'
}

export function puedeVerEmpleados(usuario) {
    return esCreador(usuario) || esAdminEmpresa(usuario) || esSupervisor(usuario)
}