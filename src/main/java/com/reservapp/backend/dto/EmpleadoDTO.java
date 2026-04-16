package com.reservapp.backend.dto;

import com.reservapp.backend.model.Empleado;
import lombok.Data;

@Data
public class EmpleadoDTO {
    private Long id;
    private Long idEmpresa;
    private String nombre;
    private String apellidos;
    private String email;
    private String telefono;
    private Empleado.Rol rol;
    private Boolean activo;
}
