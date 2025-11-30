package com.reservapp.backend.service;

import com.reservapp.backend.dto.HorarioDTO;

import java.util.List;

public interface HorarioService {
    HorarioDTO crearHorario(HorarioDTO dto);
    HorarioDTO actualizarHorario(Long id, HorarioDTO dto);
    HorarioDTO obtenerHorarioPorId(Long id);
    List<HorarioDTO> listarHorarios();
    List<HorarioDTO> listarHorariosPorEmpresa(Long idEmpresa);
    void eliminarHorario(Long id);
}
