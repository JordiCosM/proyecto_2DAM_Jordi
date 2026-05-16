package com.reservapp.backend.controller;

import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.service.HorarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/horarios")
@Tag(name = "Horarios", description = "API de los horarios")
public class HorarioController {
    private final HorarioService horarioService;

    public HorarioController(HorarioService horarioService) {
        this.horarioService = horarioService;
    }

    @GetMapping("/empresa/{idEmpresa}")
    @Operation(summary = "Listar horarios de una empresa")
    public ResponseEntity<List<HorarioDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(horarioService.listarHorariosPorEmpresa(idEmpresa));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Crear un horario")
    public ResponseEntity<HorarioDTO> create(@Valid @RequestBody HorarioDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(horarioService.crearHorario(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Actualizar un horario")
    public ResponseEntity<HorarioDTO> update(@PathVariable Long id, @Valid @RequestBody HorarioDTO dto) {
        return ResponseEntity.ok(horarioService.actualizarHorario(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Eliminar un horario")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        horarioService.eliminarHorario(id);
        return ResponseEntity.noContent().build();
    }
}