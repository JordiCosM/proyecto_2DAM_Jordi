package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.EmpresaMapper;
import com.reservapp.backend.model.*;
import com.reservapp.backend.repository.*;
import com.reservapp.backend.service.EmpresaService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class EmpresaServiceImpl implements EmpresaService {
    private final EmpresaRepository empresaRepository;
    private final EmpresaMapper empresaMapper;
    private final UsuarioRepository usuarioRepository;
    private final CiudadRepository ciudadRepository;

    public EmpresaServiceImpl(EmpresaRepository empresaRepository, EmpresaMapper empresaMapper, UsuarioRepository usuarioRepository, CiudadRepository ciudadRepository) {
        this.empresaRepository = empresaRepository;
        this.empresaMapper = empresaMapper;
        this.usuarioRepository = usuarioRepository;
        this.ciudadRepository = ciudadRepository;
    }

    @Override
    @Transactional
    public EmpresaDTO crearEmpresa(EmpresaDTO dto) {
        Empresa empresa = empresaMapper.toEntity(dto);

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario()).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        empresa.setUsuario(usuario);

        Ciudad ciudad = ciudadRepository.findById(dto.getIdCiudad()).orElseThrow(() -> new ResourceNotFoundException("Ciudad no encontrada"));
        empresa.setCiudad(ciudad);

        return empresaMapper.toDTO(empresaRepository.save(empresa));
    }

    @Override
    @Transactional
    public EmpresaDTO actualizarEmpresa(Long id, EmpresaDTO dto) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));

        empresa.setNombre(dto.getNombre());
        empresa.setDescripcion(dto.getDescripcion());
        empresa.setDireccion(dto.getDireccion());
        empresa.setTelefono(dto.getTelefono());
        empresa.setEmail(dto.getEmail());
        empresa.setSector(dto.getSector());

        if (dto.getIdUsuario() != null) {
            Usuario usuario = usuarioRepository.findById(dto.getIdUsuario()).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
            empresa.setUsuario(usuario);
        }

        if (dto.getIdCiudad() != null) {
            Ciudad ciudad = ciudadRepository.findById(dto.getIdCiudad()).orElseThrow(() -> new ResourceNotFoundException("Ciudad no encontrada"));
            empresa.setCiudad(ciudad);
        }

        return empresaMapper.toDTO(empresaRepository.save(empresa));
    }

    @Override
    public EmpresaDTO obtenerEmpresaPorId(Long id) {
        return empresaMapper.toDTO(empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada")));
    }

    @Override
    public List<EmpresaDTO> listarEmpresas() {
        return empresaRepository.findAll().stream().map(empresaMapper::toDTO).toList();
    }

    @Override
    public List<EmpresaDTO> listarEmpresasPorUsuario(Long idUsuario) {
        return empresaRepository.findByUsuarioId(idUsuario).stream().map(empresaMapper::toDTO).toList();
    }

    @Override
    public List<EmpresaDTO> listarEmpresasPorCiudad(Long idCiudad) {
        return empresaRepository.findByCiudadId(idCiudad).stream().map(empresaMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public void eliminarEmpresa(Long id) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));

        empresa.getServicios().forEach(servicio -> servicio.getReservas().stream().filter(r -> r.getEstado() == Reserva.Estado.PENDIENTE || r.getEstado() == Reserva.Estado.CONFIRMADA).forEach(r -> r.setEstado(Reserva.Estado.CANCELADA)));

        empresaRepository.delete(empresa);
    }

    @Override
    @Transactional
    public EmpresaDTO actualizarLogo(Long id, String url) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));
        empresa.setLogoUrl(url);
        return empresaMapper.toDTO(empresaRepository.save(empresa));
    }

    @Override
    @Transactional
    public EmpresaDTO agregarImagen(Long id, String url) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));
        empresa.getImagenes().add(url);
        return empresaMapper.toDTO(empresaRepository.save(empresa));
    }

    @Override
    @Transactional
    public EmpresaDTO eliminarImagen(Long id, String url) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));
        empresa.getImagenes().remove(url);
        return empresaMapper.toDTO(empresaRepository.save(empresa));
    }
}