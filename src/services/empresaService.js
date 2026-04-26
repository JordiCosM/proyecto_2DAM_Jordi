import { get, post, put, remove, postForm, deleteWithParams } from './api'

export const getEmpresasByUsuario = (idUsuario) => get(`/empresas/usuario/${idUsuario}`)
export const getEmpresa = (id) => get(`/empresas/${id}`)
export const createEmpresa = (datos) => post('/empresas', datos)
export const updateEmpresa = (id, datos) => put(`/empresas/${id}`, datos)
export const deleteEmpresa = (id) => remove(`/empresas/${id}`)

export const subirLogo = (id, file) => {
    const form = new FormData()
    form.append('file', file)
    return postForm(`/empresas/${id}/logo`, form)
}

export const subirImagen = (id, file) => {
    const form = new FormData()
    form.append('file', file)
    return postForm(`/empresas/${id}/imagenes`, form)
}

export const eliminarImagen = (id, url) =>
    deleteWithParams(`/empresas/${id}/imagenes`, { url })