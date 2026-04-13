package com.reservapp.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CrearClienteRequest {

    @NotBlank
    private String nombre;

    private String apellidos;

    @NotBlank
    @Email
    private String email;

    private String telefono;
}