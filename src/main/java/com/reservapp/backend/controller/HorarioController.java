package com.reservapp.backend.controller;


import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.service.HorarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/horarios")
public class HorarioController {
    private final HorarioService horarioService;

    public HorarioController(HorarioService horarioService) {
        this.horarioService = horarioService;
    }

    @GetMapping
    public ResponseEntity<List<HorarioDTO>> getAll() {
        return ResponseEntity.ok(horarioService.listarHorarios());
    }

    @GetMapping("/{id}")
    public ResponseEntity<HorarioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(horarioService.obtenerHorarioPorId(id));
    }

    @GetMapping("/empresa/{idEmpresa}")
    public ResponseEntity<List<HorarioDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(horarioService.listarHorariosPorEmpresa(idEmpresa));
    }

    @PostMapping
    public ResponseEntity<HorarioDTO> create(@RequestBody HorarioDTO dto) {
        return ResponseEntity.ok(horarioService.crearHorario(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<HorarioDTO> update(@PathVariable Long id, @RequestBody HorarioDTO dto) {
        return ResponseEntity.ok(horarioService.actualizarHorario(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        horarioService.eliminarHorario(id);
        return ResponseEntity.noContent().build();
    }
}
