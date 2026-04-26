const BASE_URL = 'http://localhost:8080/api'
export const IMG_BASE_URL = 'http://localhost:8080'

function getToken() {
    return localStorage.getItem('token')
}

function cerrarSesionPorExpiracion() {
    localStorage.removeItem('token')
    localStorage.removeItem('usuario')
    window.location.href = '/login'
}

async function handleResponse(response) {
    if (response.status === 401) {
        cerrarSesionPorExpiracion()
        throw new Error('Sesión expirada')
    }
    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.message || `Error ${response.status}`)
    }
    if (response.status === 204) return null
    return response.json()
}

async function request(endpoint, options = {}) {
    const url = `${BASE_URL}${endpoint}`
    const config = {
        headers: {
            'Content-Type': 'application/json',
            ...(getToken() && { Authorization: `Bearer ${getToken()}` }),
            ...options.headers,
        },
        ...options,
    }
    return handleResponse(await fetch(url, config))
}

async function requestForm(endpoint, method, formData) {
    const url = `${BASE_URL}${endpoint}`
    const config = {
        method,
        headers: {
            ...(getToken() && { Authorization: `Bearer ${getToken()}` }),
        },
        body: formData,
    }
    return handleResponse(await fetch(url, config))
}

export const get = (endpoint) => request(endpoint)
export const post = (endpoint, body) => request(endpoint, { method: 'POST', body: JSON.stringify(body) })
export const put = (endpoint, body) => request(endpoint, { method: 'PUT', body: JSON.stringify(body) })
export const patch = (endpoint, body) => request(endpoint, { method: 'PATCH', ...(body ? { body: JSON.stringify(body) } : {}) })
export const remove = (endpoint) => request(endpoint, { method: 'DELETE' })

export const postForm = (endpoint, formData) => requestForm(endpoint, 'POST', formData)
export const deleteWithParams = (endpoint, params) => {
    const query = new URLSearchParams(params).toString()
    return request(`${endpoint}?${query}`, { method: 'DELETE' })
}