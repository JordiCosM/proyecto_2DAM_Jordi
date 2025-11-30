package com.reservapp.backend.repository;

import com.reservapp.backend.model.Horario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HorarioRepository extends JpaRepository<Horario, Long> {
    List<Horario> findByEmpresaId(Long empresaId);
    List<Horario> findByDia(String dia);
}
