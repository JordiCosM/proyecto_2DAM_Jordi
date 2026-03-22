package com.reservapp.backend.service;

import com.reservapp.backend.dto.EmpresaDTO;

import java.util.List;

public interface EmpresaService {
    EmpresaDTO crearEmpresa(EmpresaDTO dto);
    EmpresaDTO actualizarEmpresa(Long id, EmpresaDTO dto);
    EmpresaDTO obtenerEmpresaPorId(Long id);
    List<EmpresaDTO> listarEmpresas();
    List<EmpresaDTO> listarEmpresasPorUsuario(Long idUsuario);
    List<EmpresaDTO> listarEmpresasPorCiudad(Long idCiudad);
    void eliminarEmpresa(Long id);
}
