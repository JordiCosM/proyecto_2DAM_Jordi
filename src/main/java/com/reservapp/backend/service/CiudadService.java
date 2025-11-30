package com.reservapp.backend.service;

import com.reservapp.backend.dto.CiudadDTO;

import java.util.List;

public interface CiudadService {
    CiudadDTO crearCiudad(CiudadDTO dto);
    CiudadDTO actualizarCiudad(Long id, CiudadDTO dto);
    CiudadDTO obtenerCiudadPorId(Long id);
    List<CiudadDTO> listarCiudades();
    List<CiudadDTO> listarCiudadesPorProvincia(Long idProvincia);
    void eliminarCiudad(Long id);
}
