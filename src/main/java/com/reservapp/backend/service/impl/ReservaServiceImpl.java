package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.ReservaMapper;
import com.reservapp.backend.model.Empleado;
import com.reservapp.backend.model.Reserva;
import com.reservapp.backend.model.Servicio;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.EmpleadoRepository;
import com.reservapp.backend.repository.ReservaRepository;
import com.reservapp.backend.repository.ServicioRepository;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.service.ReservaService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReservaServiceImpl implements ReservaService {
    private final ReservaRepository reservaRepository;
    private final ReservaMapper reservaMapper;
    private final UsuarioRepository usuarioRepository;
    private final ServicioRepository servicioRepository;
    private final EmpleadoRepository empleadoRepository;

    public ReservaServiceImpl(ReservaRepository reservaRepository, ReservaMapper reservaMapper, UsuarioRepository usuarioRepository, ServicioRepository servicioRepository, EmpleadoRepository empleadoRepository) {
        this.reservaRepository = reservaRepository;
        this.reservaMapper = reservaMapper;
        this.usuarioRepository = usuarioRepository;
        this.servicioRepository = servicioRepository;
        this.empleadoRepository = empleadoRepository;
    }

    @Override
    @Transactional
    public ReservaDTO crearReserva(ReservaDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario()).orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado"));

        Servicio servicio = servicioRepository.findById(dto.getIdServicio()).orElseThrow(() -> new ResourceNotFoundException("Servicio no encontrado"));

        int reservasActivas = reservaRepository.contarReservasSolapadas(servicio.getId(), dto.getFecha(), dto.getHoraInicio(), dto.getHoraFin());

        if (reservasActivas >= servicio.getCapacidad()) {
            throw new BadRequestException("No hay disponibilidad para ese servicio en la franja horaria seleccionada");
        }

        Reserva reserva = new Reserva();
        reserva.setUsuario(usuario);
        reserva.setServicio(servicio);
        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());
        reserva.setEstado(dto.getEstado() != null ? dto.getEstado() : Reserva.Estado.PENDIENTE);

        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public ReservaDTO asignarEmpleados(Long idReserva, List<Long> idEmpleados) {
        Reserva reserva = reservaRepository.findById(idReserva).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        Long idEmpresa = reserva.getServicio().getEmpresa().getId();

        List<Empleado> empleados = idEmpleados.stream().map(idEmpleado -> {
            Empleado empleado = empleadoRepository.findById(idEmpleado).orElseThrow(() -> new ResourceNotFoundException("Empleado no encontrado: " + idEmpleado));
            if (!empleado.getEmpresa().getId().equals(idEmpresa)) {
                throw new BadRequestException("El empleado " + idEmpleado + " no pertenece a la empresa de esta reserva");
            }
            return empleado;
        }).toList();

        reserva.setEmpleados(new ArrayList<>(empleados));
        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public ReservaDTO desasignarEmpleado(Long idReserva, Long idEmpleado) {
        Reserva reserva = reservaRepository.findById(idReserva).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        reserva.getEmpleados().removeIf(e -> e.getId().equals(idEmpleado));
        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public ReservaDTO actualizarReserva(Long id, ReservaDTO dto) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));

        reserva.setFecha(dto.getFecha());
        reserva.setHoraInicio(dto.getHoraInicio());
        reserva.setHoraFin(dto.getHoraFin());
        reserva.setEstado(dto.getEstado());

        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    public ReservaDTO obtenerReservaPorId(Long id) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
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
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        reserva.setEstado(nuevoEstado);
        return reservaMapper.toDTO(reservaRepository.save(reserva));
    }

    @Override
    @Transactional
    public void cancelarReserva(Long id) {
        Reserva reserva = reservaRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Reserva no encontrada"));
        reserva.setEstado(Reserva.Estado.CANCELADA);
        reservaRepository.save(reserva);
    }
}