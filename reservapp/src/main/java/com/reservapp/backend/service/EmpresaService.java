package com.reservapp.backend.service;

import com.reservapp.backend.dto.EmpresaDTO;

import java.util.List;

public interface EmpresaService {
    EmpresaDTO crearEmpresa(EmpresaDTO dto);
    EmpresaDTO actualizarEmpresa(Long id, EmpresaDTO dto);
    EmpresaDTO obtenerEmpresaPorId(Long id);
    List<EmpresaDTO> listarEmpresas();
    List<EmpresaDTO> listarEmpresasPorUsuario(Long idUsuario);
    void eliminarEmpresa(Long id);

    EmpresaDTO actualizarLogo(Long id, String url);
    EmpresaDTO agregarImagen(Long id, String url);
    EmpresaDTO eliminarImagen(Long id, String url);
}