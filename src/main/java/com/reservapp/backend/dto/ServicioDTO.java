package com.reservapp.backend.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ServicioDTO {
    private Long id;
    private Long idEmpresa;
    private String nombre;
    private String descripcion;
    private Integer duracion;
    private BigDecimal precio;
    private Integer capacidad;
}
