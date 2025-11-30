package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.service.ServicioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/servicios")
public class ServicioController {
    private final ServicioService servicioService;

    public ServicioController(ServicioService servicioService) {
        this.servicioService = servicioService;
    }

    @GetMapping
    public ResponseEntity<List<ServicioDTO>> getAll() {
        return ResponseEntity.ok(servicioService.listarServicios());
    }

    @GetMapping("/empresa/{idEmpresa}")
    public ResponseEntity<List<ServicioDTO>> getByEmpresa(Long idEmpresa) {
        return ResponseEntity.ok(servicioService.listarServiciosPorEmpresa(idEmpresa));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ServicioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(servicioService.obtenerServicioPorId(id));
    }

    @PostMapping
    public ResponseEntity<ServicioDTO> create(@RequestBody ServicioDTO dto) {
        return ResponseEntity.ok(servicioService.crearServicio(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ServicioDTO> update(@PathVariable Long id, @RequestBody ServicioDTO dto) {
        return ResponseEntity.ok(servicioService.actualizarServicio(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        servicioService.eliminarServicio(id);
        return ResponseEntity.noContent().build();
    }
}
