import { get, post, put, remove } from './api'

export const getEmpresasByUsuario = (idUsuario) => get(`/empresas/usuario/${idUsuario}`)
export const getEmpresa = (id) => get(`/empresas/${id}`)
export const createEmpresa = (datos) => post('/empresas', datos)
export const updateEmpresa = (id, datos) => put(`/empresas/${id}`, datos)
export const deleteEmpresa = (id) => remove(`/empresas/${id}`)