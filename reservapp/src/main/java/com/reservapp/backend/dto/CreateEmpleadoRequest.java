package com.reservapp.backend.dto;

import com.reservapp.backend.model.Empleado;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreateEmpleadoRequest {
    @NotNull
    private Long idEmpresa;

    @NotBlank
    private String nombre;

    private String apellidos;

    @NotBlank
    @Email
    private String email;

    @NotBlank
    @Size(min = 8)
    private String password;

    private String telefono;

    @NotNull
    private Empleado.Rol rol;
}
