package com.reservapp.backend.service;

import com.reservapp.backend.dto.ReservaDTO;

import java.util.List;

public interface ReservaService {
    ReservaDTO crearReserva(ReservaDTO dto);
    ReservaDTO actualizarReserva(Long id, ReservaDTO dto);
    ReservaDTO obtenerReservaPorId(Long id);
    List<ReservaDTO> listarReservas();
    List<ReservaDTO> listarReservasPorUsuario(Long idUsuario);
    List<ReservaDTO> listarReservasPorServicio(Long idServicio);
    void cancelarReserva(Long id);
}
