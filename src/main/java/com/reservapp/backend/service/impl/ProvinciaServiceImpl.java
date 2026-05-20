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
    public List<ProvinciaDTO> listarProvincias() {
        return provinciaRepository.findAll().stream().map(provinciaMapper::toDTO).toList();
    }
}