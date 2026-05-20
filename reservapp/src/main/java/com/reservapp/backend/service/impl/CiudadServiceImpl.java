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
    public List<CiudadDTO> listarCiudades() {
        return ciudadRepository.findAll().stream().map(ciudadMapper::toDTO).toList();
    }

    @Override
    public List<CiudadDTO> listarCiudadesPorProvincia(Long idProvincia) {
        return ciudadRepository.findByProvinciaId(idProvincia).stream().map(ciudadMapper::toDTO).toList();
    }
}