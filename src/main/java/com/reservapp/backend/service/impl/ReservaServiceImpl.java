package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.ReservaMapper;
import com.reservapp.backend.model.Reserva;
import com.reservapp.backend.model.Servicio;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.ReservaRepository;
import com.reservapp.backend.repository.ServicioRepository;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.service.ReservaService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReservaServiceImpl implements ReservaService {
    private final ReservaRepository reservaRepository;
    private final ReservaMapper reservaMapper;
    private final UsuarioRepository usuarioRepository;
    private final ServicioRepository servicioRepository;

    public ReservaServiceImpl(ReservaRepository reservaRepository, ReservaMapper reservaMapper, UsuarioRepository usuarioRepository, ServicioRepository servicioRepository) {
        this.reservaRepository = reservaRepository;
        this.reservaMapper = reservaMapper;
        this.usuarioRepository = usuarioRepository;
        this.servicioRepository = servicioRepository;
    }

    @Override
    public ReservaDTO crearReserva(ReservaDTO dto) {
//        Reserva reserva = reservaMapper.toEntity(dto);
//        Reserva guardado = reservaRepository.save(reserva);
//        return reservaMapper.toDTO(guardado);

        Reserva reserva = new Reserva();

        Usuario usuario = usuarioRepository.findById(Long.valueOf(dto.getIdUsuario()))
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        reserva.setUsuario(usuario);

        Servicio servicio = servicioRepository.findById(Long.valueOf(dto.getIdServicio()))
                .orElseThrow(() -> new RuntimeException("Servicio no encontrado"));
        reserva.setServicio(servicio);

        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());

        if(dto.getEstado() != null) {
            reserva.setEstado(Reserva.Estado.valueOf(dto.getEstado()));
        } else {
            reserva.setEstado(Reserva.Estado.pendiente);
        }

        Reserva guardado = reservaRepository.save(reserva);
        return reservaMapper.toDTO(guardado);
    }

    @Override
    public ReservaDTO actualizarReserva(Long id, ReservaDTO dto) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());
        reserva.setEstado(Reserva.Estado.valueOf(dto.getEstado().toLowerCase()));

        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    public ReservaDTO obtenerReservaPorId(Long id) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        return reservaMapper.toDTO(reserva);
    }

    @Override
    public List<ReservaDTO> listarReservas() {
        return reservaRepository.findAll().stream().map(reservaMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public List<ReservaDTO> listarReservasPorUsuario(Long idUsuario) {
        return reservaRepository.findByUsuarioId(idUsuario).stream().map(reservaMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public List<ReservaDTO> listarReservasPorServicio(Long idServicio) {
        return reservaRepository.findByServicioId(idServicio).stream().map(reservaMapper::toDTO).collect(Collectors.toList());
    }

    @Override
    public void cancelarReserva(Long id) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        reserva.setEstado(Reserva.Estado.cancelada);
        reservaRepository.save(reserva);
    }
}
