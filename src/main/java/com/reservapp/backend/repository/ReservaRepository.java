package com.reservapp.backend.repository;

import com.reservapp.backend.model.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Long> {
    List<Reserva> findByUsuarioId(Long idUsuario);

    List<Reserva> findByServicioId(Long idServicio);

    List<Reserva> findByFecha(LocalDate fecha);

    List<Reserva> findByEstado(String estado);
}
