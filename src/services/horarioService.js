import { get, post, put, remove } from './api'

export const getHorariosByEmpresa = (idEmpresa) => get(`/horarios/empresa/${idEmpresa}`)
export const createHorario = (datos) => post('/horarios', datos)
export const updateHorario = (id, datos) => put(`/horarios/${id}`, datos)
export const deleteHorario = (id) => remove(`/horarios/${id}`)