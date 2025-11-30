package com.reservapp.backend.service;

import com.reservapp.backend.dto.ProvinciaDTO;

import java.util.List;

public interface ProvinciaService {
    ProvinciaDTO crearProvincia(ProvinciaDTO dto);
    ProvinciaDTO actualizarProvincia(Long id, ProvinciaDTO dto);
    ProvinciaDTO obtenerProvinciaPorId(Long id);
    List<ProvinciaDTO> listarProvincias();
    void eliminarProvincia(Long id);
}
