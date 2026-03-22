package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.ProvinciaDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.ProvinciaMapper;
import com.reservapp.backend.model.Provincia;
import com.reservapp.backend.repository.ProvinciaRepository;
import com.reservapp.backend.service.ProvinciaService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProvinciaServiceImpl implements ProvinciaService {
    private final ProvinciaRepository provinciaRepository;
    private final ProvinciaMapper provinciaMapper;

    public ProvinciaServiceImpl(ProvinciaRepository provinciaRepository, ProvinciaMapper provinciaMapper) {
        this.provinciaRepository = provinciaRepository;
        this.provinciaMapper = provinciaMapper;
    }

    @Override
    @Transactional
    public ProvinciaDTO crearProvincia(ProvinciaDTO dto) {
        Provincia provincia = provinciaMapper.toEntity(dto);
        return provinciaMapper.toDTO(provinciaRepository.save(provincia));
    }

    @Override
    @Transactional
    public ProvinciaDTO actualizarProvincia(Long id, ProvinciaDTO dto) {
        Provincia provincia = provinciaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Provincia no encontrada"));

        provincia.setNombre(dto.getNombre());

        return provinciaMapper.toDTO(provinciaRepository.save(provincia));
    }

    @Override
    public ProvinciaDTO obtenerProvinciaPorId(Long id) {
        Provincia provincia = provinciaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Provincia no encontrada"));
        return provinciaMapper.toDTO(provincia);
    }

    @Override
    public List<ProvinciaDTO> listarProvincias() {
        return provinciaRepository.findAll().stream().map(provinciaMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public void eliminarProvincia(Long id) {
        if (!provinciaRepository.existsById(id)) {
            throw new ResourceNotFoundException("Provincia no encontrada");
        }
        provinciaRepository.deleteById(id);
    }
}