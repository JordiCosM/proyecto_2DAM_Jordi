const BASE_URL = 'http://localhost:8080/api'

function getToken() {
    return localStorage.getItem('token')
}

function cerrarSesionPorExpiracion() {
    localStorage.removeItem('token')
    localStorage.removeItem('usuario')
    window.location.href = '/login'
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

    const response = await fetch(url, config)

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

export const get = (endpoint) => request(endpoint)
export const post = (endpoint, body) => request(endpoint, { method: 'POST', body: JSON.stringify(body) })
export const put = (endpoint, body) => request(endpoint, { method: 'PUT', body: JSON.stringify(body) })
export const patch = (endpoint, body) => request(endpoint, { method: 'PATCH', ...(body ? { body: JSON.stringify(body) } : {}) })
export const remove = (endpoint) => request(endpoint, { method: 'DELETE' })