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
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class ReservaServiceImpl implements ReservaService {
    private final ReservaRepository reservaRepository;
    private final ReservaMapper reservaMapper;
    private final UsuarioRepository usuarioRepository;
    private final ServicioRepository servicioRepository;

    public ReservaServiceImpl(ReservaRepository reservaRepository, ReservaMapper reservaMapper,
                              UsuarioRepository usuarioRepository, ServicioRepository servicioRepository) {
        this.reservaRepository = reservaRepository;
        this.reservaMapper = reservaMapper;
        this.usuarioRepository = usuarioRepository;
        this.servicioRepository = servicioRepository;
    }

    @Override
    @Transactional
    public ReservaDTO crearReserva(ReservaDTO dto) {
        Reserva reserva = new Reserva();

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));
        reserva.setUsuario(usuario);

        Servicio servicio = servicioRepository.findById(dto.getIdServicio())
                .orElseThrow(() -> new ResourceNotFoundException("Servicio no encontrado"));
        reserva.setServicio(servicio);

        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());
        reserva.setEstado(dto.getEstado() != null ? dto.getEstado() : Reserva.Estado.PENDIENTE);

        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public ReservaDTO actualizarReserva(Long id, ReservaDTO dto) {
        Reserva reserva = reservaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());
        reserva.setEstado(dto.getEstado());

        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    public ReservaDTO obtenerReservaPorId(Long id) {
        Reserva reserva = reservaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        return reservaMapper.toDTO(reserva);
    }

    @Override
    public List<ReservaDTO> listarReservas() {
        return reservaRepository.findAll().stream().map(reservaMapper::toDTO).toList();
    }

    @Override
    public List<ReservaDTO> listarReservasPorUsuario(Long idUsuario) {
        return reservaRepository.findByUsuarioId(idUsuario).stream().map(reservaMapper::toDTO).toList();
    }

    @Override
    public List<ReservaDTO> listarReservasPorServicio(Long idServicio) {
        return reservaRepository.findByServicioId(idServicio).stream().map(reservaMapper::toDTO).toList();
    }

    @Override
    public List<ReservaDTO> listarReservasPorFecha(LocalDate fecha) {
        return reservaRepository.findByFecha(fecha).stream().map(reservaMapper::toDTO).toList();
    }

    @Override
    public List<ReservaDTO> listarReservasPorServicioYFecha(Long idServicio, LocalDate fecha) {
        return reservaRepository.findByServicioIdAndFecha(idServicio, fecha).stream().map(reservaMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public ReservaDTO cambiarEstado(Long id, Reserva.Estado nuevoEstado) {
        Reserva reserva = reservaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        reserva.setEstado(nuevoEstado);
        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public void cancelarReserva(Long id) {
        Reserva reserva = reservaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        reserva.setEstado(Reserva.Estado.CANCELADA);
        reservaRepository.save(reserva);
    }
}