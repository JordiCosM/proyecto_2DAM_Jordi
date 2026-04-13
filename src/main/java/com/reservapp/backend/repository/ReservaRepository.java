package com.reservapp.backend.repository;

import com.reservapp.backend.model.Reserva;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface ReservaRepository extends JpaRepository<Reserva, Long> {
    List<Reserva> findByUsuarioId(Long usuarioId);

    List<Reserva> findByServicioId(Long servicioId);

    List<Reserva> findByFecha(LocalDate fecha);

    List<Reserva> findByEstado(Reserva.Estado estado);

    List<Reserva> findByServicioIdAndFecha(Long servicioId, LocalDate fecha);

    @Query("SELECT COUNT(r) FROM Reserva r WHERE r.servicio.id = :idServicio " +
            "AND r.fecha = :fecha " +
            "AND r.estado NOT IN ('CANCELADA', 'FINALIZADA') " +
            "AND r.horaInicio < :horaFin AND r.horaFin > :horaInicio")
    int contarReservasSolapadas(@Param("idServicio") Long idServicio,
                                @Param("fecha") LocalDate fecha,
                                @Param("horaInicio") LocalTime horaInicio,
                                @Param("horaFin") LocalTime horaFin);
}
