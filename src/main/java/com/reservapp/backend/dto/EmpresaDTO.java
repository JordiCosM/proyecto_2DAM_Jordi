package com.reservapp.backend.dto;

import lombok.Data;

@Data
public class EmpresaDTO {
    private Long id;
    private Long idUsuario;
    private Long idCiudad;
    private String nombre;
    private String descripcion;
    private String direccion;
    private String telefono;
    private String email;
    private String sector;
    private String logoUrl;
}
