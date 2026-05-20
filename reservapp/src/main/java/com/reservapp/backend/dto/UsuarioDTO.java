package com.reservapp.backend.dto;

import com.reservapp.backend.model.Usuario;
import lombok.Data;

@Data
public class UsuarioDTO {
    private Long id;
    private String nombre;
    private String apellidos;
    private String email;
    private String telefono;
    private Usuario.Rol rol;
}
