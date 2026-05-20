package com.reservapp.backend.service;

import com.reservapp.backend.dto.CiudadDTO;

import java.util.List;

public interface CiudadService {
    List<CiudadDTO> listarCiudades();
    List<CiudadDTO> listarCiudadesPorProvincia(Long idProvincia);
}
