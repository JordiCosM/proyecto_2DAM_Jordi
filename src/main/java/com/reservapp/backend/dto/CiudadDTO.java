package com.reservapp.backend.dto;

import lombok.Data;

@Data
public class CiudadDTO {
    private Long id;
    private String nombre;
    private String codPostal;
    private Long idProvincia;
}
