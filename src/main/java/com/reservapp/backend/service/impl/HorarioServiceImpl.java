package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.HorarioMapper;
import com.reservapp.backend.model.Horario;
import com.reservapp.backend.repository.HorarioRepository;
import com.reservapp.backend.service.HorarioService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class HorarioServiceImpl implements HorarioService {
    private final HorarioRepository horarioRepository;
    private final HorarioMapper horarioMapper;

    public HorarioServiceImpl(HorarioRepository horarioRepository, HorarioMapper horarioMapper) {
        this.horarioRepository = horarioRepository;
        this.horarioMapper = horarioMapper;
    }

    @Override
    public HorarioDTO crearHorario(HorarioDTO dto) {
        Horario horario = horarioMapper.toEntity(dto);
        Horario guardado = horarioRepository.save(horario);
        return horarioMapper.toDTO(guardado);
    }

    @Override
    public HorarioDTO actualizarHorario(Long id, HorarioDTO dto) {
        Horario horario = horarioRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Horario no encontrado"));

        horario.setDia(Horario.Dia.valueOf(dto.getDia()));
        horario.setApertura(dto.getApertura());
        horario.setCierre(dto.getCierre());

        return horarioMapper.toDTO(horarioRepository.save(horario));
    }

    @Override
    public HorarioDTO obtenerHorarioPorId(Long id) {
        Horario horario = horarioRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Horario no encontrado"));
        return horarioMapper.toDTO(horario);
    }

    @Override
    public List<HorarioDTO> listarHorarios() {
        return horarioRepository.findAll().stream().map(horarioMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public List<HorarioDTO> listarHorariosPorEmpresa(Long idEmpresa) {
        return horarioRepository.findByEmpresaId(idEmpresa).stream().map(horarioMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public void eliminarHorario(Long id) {
        if (!horarioRepository.existsById(id)) {
            throw new ResourceNotFoundException("Horario no encontrado");
        }

        horarioRepository.deleteById(id);
    }
}
