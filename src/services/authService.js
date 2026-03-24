import { post } from './api'

export const login = (email, password) => post('/auth/login', { email, password })
export const register = (datos) => post('/auth/register', datos)
export const forgotPassword = (email) => post('/auth/forgot-password', { email })
export const resetPassword = (token, nuevaPassword) => post('/auth/reset-password', { token, nuevaPassword })