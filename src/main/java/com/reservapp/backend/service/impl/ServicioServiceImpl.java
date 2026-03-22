package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.ServicioMapper;
import com.reservapp.backend.model.Servicio;
import com.reservapp.backend.repository.EmpresaRepository;
import com.reservapp.backend.repository.ServicioRepository;
import com.reservapp.backend.service.ServicioService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ServicioServiceImpl implements ServicioService {
    private final ServicioRepository servicioRepository;
    private final ServicioMapper servicioMapper;
    private final EmpresaRepository empresaRepository;

    public ServicioServiceImpl(ServicioRepository servicioRepository, ServicioMapper servicioMapper,
                               EmpresaRepository empresaRepository) {
        this.servicioRepository = servicioRepository;
        this.servicioMapper = servicioMapper;
        this.empresaRepository = empresaRepository;
    }

    @Override
    @Transactional
    public ServicioDTO crearServicio(ServicioDTO dto) {
        Servicio servicio = servicioMapper.toEntity(dto);

        servicio.setEmpresa(empresaRepository.findById(dto.getIdEmpresa())
                .orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada")));

        return servicioMapper.toDTO(servicioRepository.save(servicio));
    }

    @Override
    @Transactional
    public ServicioDTO actualizarServicio(Long id, ServicioDTO dto) {
        Servicio servicio = servicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Servicio no encontrado"));

        servicio.setNombre(dto.getNombre());
        servicio.setDescripcion(dto.getDescripcion());
        servicio.setDuracion(dto.getDuracion());
        servicio.setPrecio(dto.getPrecio());

        if (dto.getIdEmpresa() != null) {
            servicio.setEmpresa(empresaRepository.findById(dto.getIdEmpresa())
                    .orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada")));
        }

        return servicioMapper.toDTO(servicioRepository.save(servicio));
    }

    @Override
    public ServicioDTO obtenerServicioPorId(Long id) {
        Servicio servicio = servicioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Servicio no encontrado"));
        return servicioMapper.toDTO(servicio);
    }

    @Override
    public List<ServicioDTO> listarServicios() {
        return servicioRepository.findAll().stream().map(servicioMapper::toDTO).toList();
    }

    @Override
    public List<ServicioDTO> listarServiciosPorEmpresa(Long idEmpresa) {
        return servicioRepository.findByEmpresaId(idEmpresa).stream().map(servicioMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public void eliminarServicio(Long id) {
        if (!servicioRepository.existsById(id)) {
            throw new ResourceNotFoundException("Servicio no encontrado");
        }
        servicioRepository.deleteById(id);
    }
}