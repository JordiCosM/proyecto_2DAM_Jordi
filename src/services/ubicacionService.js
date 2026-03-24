import { get } from './api'

export const getProvincias = () => get('/provincias')
export const getCiudadesByProvincia = (idProvincia) => get(`/ciudades/provincia/${idProvincia}`)