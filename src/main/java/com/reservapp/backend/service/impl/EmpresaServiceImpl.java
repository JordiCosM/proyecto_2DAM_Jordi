package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.EmpresaMapper;
import com.reservapp.backend.model.Ciudad;
import com.reservapp.backend.model.Empresa;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.CiudadRepository;
import com.reservapp.backend.repository.EmpresaRepository;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.service.EmpresaService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

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
    public EmpresaDTO crearEmpresa(EmpresaDTO dto) {
        Empresa empresa = empresaMapper.toEntity(dto);

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario()).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        empresa.setUsuario(usuario);

        Ciudad ciudad = ciudadRepository.findById(dto.getIdCiudad()).orElseThrow(() -> new ResourceNotFoundException("Ciudad no encontrada"));
        empresa.setCiudad(ciudad);

        Empresa guardado = empresaRepository.save(empresa);
        return empresaMapper.toDTO(guardado);
    }

    @Override
    public EmpresaDTO actualizarEmpresa(Long id, EmpresaDTO dto) {
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));

        empresa.setNombre(dto.getNombre());
        empresa.setDescripcion(dto.getDescripcion());
        empresa.setDireccion(dto.getDireccion());
        empresa.setTelefono(dto.getTelefono());
        empresa.setEmail(dto.getEmail());
        empresa.setSector(dto.getSector());
        empresa.setLogoUrl(dto.getLogoUrl());

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
        Empresa empresa = empresaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));
        return empresaMapper.toDTO(empresa);
    }

    @Override
    public List<EmpresaDTO> listarEmpresas() {
        return empresaRepository.findAll().stream().map(empresaMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public void eliminarEmpresa(Long id) {
        if (!empresaRepository.existsById(id)) {
            throw new ResourceNotFoundException("Empresa no encontrada");
        }

        empresaRepository.deleteById(id);
    }
}
