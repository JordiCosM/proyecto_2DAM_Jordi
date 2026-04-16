package com.reservapp.backend.repository;

import com.reservapp.backend.model.Empleado;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmpleadoRepository extends JpaRepository<Empleado, Long> {
    Optional<Empleado> findByEmail(String email);

    boolean existsByEmail(String email);

    List<Empleado> findByEmpresaId(Long idEmpresa);

    List<Empleado> findByEmpresaIdAndActivo(Long idEmpresa, Boolean activo);
}
