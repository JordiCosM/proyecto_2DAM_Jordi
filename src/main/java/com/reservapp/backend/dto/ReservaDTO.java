package com.reservapp.backend.dto;

import com.reservapp.backend.model.Reserva;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class ReservaDTO {
    private Long id;
    private Long idUsuario;
    private Long idServicio;
    private LocalDate fecha;
    private LocalTime horaInicio;
    private LocalTime horaFin;
    private Reserva.Estado estado;
}
