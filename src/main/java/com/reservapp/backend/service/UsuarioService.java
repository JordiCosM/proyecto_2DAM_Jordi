package com.reservapp.backend.service;

import com.reservapp.backend.dto.UsuarioDTO;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;

public interface UsuarioService extends UserDetailsService {
    UsuarioDTO crearUsuario(UsuarioDTO dto);
    UsuarioDTO actualizarUsuario(Long id, UsuarioDTO dto);
    UsuarioDTO obtenerUsuarioPorId(Long id);
    List<UsuarioDTO> listarUsuarios();
    void eliminarUsuario(Long id);
}
