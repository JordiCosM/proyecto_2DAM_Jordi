package com.reservapp.backend.controller;


import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.service.HorarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/horarios")
@Tag(name = "Horarios", description = "API de las horarios")
public class HorarioController {
    private final HorarioService horarioService;

    public HorarioController(HorarioService horarioService) {
        this.horarioService = horarioService;
    }

    @GetMapping
    @Operation(summary = "Listar todos los horarios", description = "Listar todos los horarios")
    public ResponseEntity<List<HorarioDTO>> getAll() {
        return ResponseEntity.ok(horarioService.listarHorarios());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Recoger un horario", description = "Recoger un horario por su id")
    public ResponseEntity<HorarioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(horarioService.obtenerHorarioPorId(id));
    }

    @GetMapping("/empresa/{idEmpresa}")
    @Operation(summary = "Recoger un horario por empresa", description = "Recoger un horario por la id de la empresa")
    public ResponseEntity<List<HorarioDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(horarioService.listarHorariosPorEmpresa(idEmpresa));
    }

    @PostMapping
    @Operation(summary = "Crear un horario", description = "Crear un horario")
    public ResponseEntity<HorarioDTO> create(@RequestBody HorarioDTO dto) {
        return ResponseEntity.ok(horarioService.crearHorario(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar un horario", description = "Actualizar un horario por su id")
    public ResponseEntity<HorarioDTO> update(@PathVariable Long id, @RequestBody HorarioDTO dto) {
        return ResponseEntity.ok(horarioService.actualizarHorario(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar un horario", description = "Eliminar un horario por su id")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        horarioService.eliminarHorario(id);
        return ResponseEntity.noContent().build();
    }
}
