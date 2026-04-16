import { get, post, put, remove } from './api'

export const getUsuario = (id) => get(`/usuarios/${id}`)
export const getUsuarioPorEmail = (email) => get(`/usuarios/email/${encodeURIComponent(email)}`)
export const crearCliente = (datos) => post('/usuarios/cliente', datos)
export const updateUsuario = (id, datos) => put(`/usuarios/${id}`, datos)
export const deleteUsuario = (id) => remove(`/usuarios/${id}`)