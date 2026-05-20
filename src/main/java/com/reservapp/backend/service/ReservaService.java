package com.reservapp.backend.service;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.model.Reserva;

import java.time.LocalDate;
import java.util.List;

public interface ReservaService {
    ReservaDTO crearReserva(ReservaDTO dto);
    ReservaDTO actualizarReserva(Long id, ReservaDTO dto);
    List<ReservaDTO> listarReservasPorUsuario(Long idUsuario);
    List<ReservaDTO> listarReservasPorServicio(Long idServicio);
    ReservaDTO asignarEmpleados(Long idReserva, List<Long> idEmpleados);
    ReservaDTO desasignarEmpleado(Long idReserva, Long idEmpleado);
    ReservaDTO cambiarEstado(Long id, Reserva.Estado nuevoEstado);
    void cancelarReserva(Long id);
}
