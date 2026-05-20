package com.reservapp.backend.dto;

import com.reservapp.backend.model.Horario;
import lombok.Data;

import java.time.LocalTime;

@Data
public class HorarioDTO {
    private Long id;
    private Long idEmpresa;
    private Horario.Dia dia;
    private LocalTime apertura;
    private LocalTime cierre;
}
