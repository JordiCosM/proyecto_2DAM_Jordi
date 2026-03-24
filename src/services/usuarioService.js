import { get, put, remove } from './api'

export const getUsuario = (id) => get(`/usuarios/${id}`)
export const updateUsuario = (id, datos) => put(`/usuarios/${id}`, datos)
export const deleteUsuario = (id) => remove(`/usuarios/${id}`)