import { get, post, put, patch } from './api'

export const getEmpleadosByEmpresa = (idEmpresa) => get(`/empleados/empresa/${idEmpresa}`)
export const getEmpleadosActivosByEmpresa = (idEmpresa) => get(`/empleados/empresa/${idEmpresa}/activos`)
export const getEmpleado = (id) => get(`/empleados/${id}`)
export const createEmpleado = (datos) => post('/empleados', datos)
export const updateEmpleado = (id, datos) => put(`/empleados/${id}`, datos)
export const activarEmpleado = (id) => patch(`/empleados/${id}/activar`)
export const desactivarEmpleado = (id) => patch(`/empleados/${id}/desactivar`)