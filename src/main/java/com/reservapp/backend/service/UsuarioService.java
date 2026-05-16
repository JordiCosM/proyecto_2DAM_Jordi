package com.reservapp.backend.service;

import com.reservapp.backend.dto.CrearClienteRequest;
import com.reservapp.backend.dto.RegisterRequest;
import com.reservapp.backend.dto.UsuarioDTO;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UsuarioService extends UserDetailsService {
    UsuarioDTO crearCliente(CrearClienteRequest request);
    UsuarioDTO actualizarUsuario(Long id, UsuarioDTO dto);
    UsuarioDTO obtenerUsuarioPorEmail(String email);
    UsuarioDTO obtenerUsuarioPorId(Long id);
    void eliminarUsuario(Long id);
}
