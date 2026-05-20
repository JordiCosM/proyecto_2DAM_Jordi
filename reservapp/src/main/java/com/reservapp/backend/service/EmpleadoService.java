package com.reservapp.backend.service;

import com.reservapp.backend.dto.CreateEmpleadoRequest;
import com.reservapp.backend.dto.EmpleadoDTO;

import java.util.List;

public interface EmpleadoService {
    EmpleadoDTO crearEmpleado(CreateEmpleadoRequest request);

    EmpleadoDTO actualizarEmpleado(Long id, EmpleadoDTO dto);

    EmpleadoDTO obtenerEmpleadoPorId(Long id);

    List<EmpleadoDTO> listarEmpleadosPorEmpresa(Long idEmpresa);

    List<EmpleadoDTO> listarEmpleadosActivosPorEmpresa(Long idEmpresa);

    void desactivarEmpleado(Long id);

    void activarEmpleado(Long id);
}
