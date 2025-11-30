package com.reservapp.backend.service;

import com.reservapp.backend.dto.ServicioDTO;

import java.util.List;

public interface ServicioService {
    ServicioDTO crearServicio(ServicioDTO dto);
    ServicioDTO actualizarServicio(Long id, ServicioDTO dto);
    ServicioDTO obtenerServicioPorId(Long id);
    List<ServicioDTO> listarServicios();
    List<ServicioDTO> listarServiciosPorEmpresa(Long idEmpresa);
    void eliminarServicio(Long id);
}
