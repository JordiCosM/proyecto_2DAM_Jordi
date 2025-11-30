package com.reservapp.backend.repository;

import com.reservapp.backend.model.Empresa;
import com.reservapp.backend.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmpresaRepository extends JpaRepository<Empresa, Long> {
    List<Empresa> findByUsuario(Usuario usuario);
    List<Empresa> findByCiudadId(Long ciudadId);
}
