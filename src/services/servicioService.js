import { get, post, put, remove } from './api'

export const getServiciosByEmpresa = (idEmpresa) => get(`/servicios/empresa/${idEmpresa}`)
export const getServicio = (id) => get(`/servicios/${id}`)
export const createServicio = (datos) => post('/servicios', datos)
export const updateServicio = (id, datos) => put(`/servicios/${id}`, datos)
export const deleteServicio = (id) => remove(`/servicios/${id}`)