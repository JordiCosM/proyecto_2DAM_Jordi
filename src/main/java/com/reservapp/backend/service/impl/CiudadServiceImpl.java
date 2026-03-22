package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.CiudadDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.CiudadMapper;
import com.reservapp.backend.model.Ciudad;
import com.reservapp.backend.repository.CiudadRepository;
import com.reservapp.backend.service.CiudadService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CiudadServiceImpl implements CiudadService {
    private final CiudadRepository ciudadRepository;
    private final CiudadMapper ciudadMapper;

    public CiudadServiceImpl(CiudadRepository ciudadRepository, CiudadMapper ciudadMapper) {
        this.ciudadRepository = ciudadRepository;
        this.ciudadMapper = ciudadMapper;
    }

    @Override
    @Transactional
    public CiudadDTO crearCiudad(CiudadDTO dto) {
        Ciudad ciudad = ciudadMapper.toEntity(dto);
        return ciudadMapper.toDTO(ciudadRepository.save(ciudad));
    }

    @Override
    @Transactional
    public CiudadDTO actualizarCiudad(Long id, CiudadDTO dto) {
        Ciudad ciudad = ciudadRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ciudad no encontrada"));

        ciudad.setNombre(dto.getNombre());
        ciudad.setCodPostal(dto.getCodPostal());

        return ciudadMapper.toDTO(ciudadRepository.save(ciudad));
    }

    @Override
    public CiudadDTO obtenerCiudadPorId(Long id) {
        Ciudad ciudad = ciudadRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ciudad no encontrada"));
        return ciudadMapper.toDTO(ciudad);
    }

    @Override
    public List<CiudadDTO> listarCiudades() {
        return ciudadRepository.findAll().stream().map(ciudadMapper::toDTO).toList();
    }

    @Override
    public List<CiudadDTO> listarCiudadesPorProvincia(Long idProvincia) {
        return ciudadRepository.findByProvinciaId(idProvincia).stream().map(ciudadMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public void eliminarCiudad(Long id) {
        if (!ciudadRepository.existsById(id)) {
            throw new ResourceNotFoundException("Ciudad no encontrada");
        }
        ciudadRepository.deleteById(id);
    }
}