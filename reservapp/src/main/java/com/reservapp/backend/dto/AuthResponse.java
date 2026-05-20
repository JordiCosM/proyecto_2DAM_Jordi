package com.reservapp.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class AuthResponse {
    private String token;
    private Long idUsuario;
    private String nombre;
    private String email;
    private String rol;
    private String tipo;
    private Long idEmpresa;
}
