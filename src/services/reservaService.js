import { get, post, put, remove, patch } from './api'

export const getReservasByServicio = (idServicio) => get(`/reservas/servicio/${idServicio}`)
export const getReservasByUsuario = (idUsuario) => get(`/reservas/usuario/${idUsuario}`)
export const getReserva = (id) => get(`/reservas/${id}`)
export const createReserva = (datos) => post('/reservas', datos)
export const updateReserva = (id, datos) => put(`/reservas/${id}`, datos)
export const updateEstado = (id, estado) => patch(`/reservas/${id}/estado`, { estado })
export const deleteReserva = (id) => remove(`/reservas/${id}`)