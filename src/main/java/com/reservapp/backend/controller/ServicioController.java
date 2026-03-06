package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.service.ServicioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/servicios")
@Tag(name = "Servicios", description = "API de los servicios")
public class ServicioController {
    private final ServicioService servicioService;

    public ServicioController(ServicioService servicioService) {
        this.servicioService = servicioService;
    }

    @GetMapping
    @Operation(summary = "Listar todos los servicios", description = "Listar todos los servicios")
    public ResponseEntity<List<ServicioDTO>> getAll() {
        return ResponseEntity.ok(servicioService.listarServicios());
    }

    @GetMapping("/empresa/{idEmpresa}")
    @Operation(summary = "Listar todos los servicios de una empresa", description = "Listar todos los servicios de una empresa por su id")
    public ResponseEntity<List<ServicioDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(servicioService.listarServiciosPorEmpresa(idEmpresa));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Recoger un servicio", description = "Recoger un servicio por su id")
    public ResponseEntity<ServicioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(servicioService.obtenerServicioPorId(id));
    }

    @PostMapping
    @Operation(summary = "Crear un servicio", description = "Crear un servicio")
    public ResponseEntity<ServicioDTO> create(@RequestBody ServicioDTO dto) {
        return ResponseEntity.ok(servicioService.crearServicio(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar un servicio", description = "Actualizar un servicio por su id")
    public ResponseEntity<ServicioDTO> update(@PathVariable Long id, @RequestBody ServicioDTO dto) {
        return ResponseEntity.ok(servicioService.actualizarServicio(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar un servicio", description = "Eliminar un servicio por su id")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        servicioService.eliminarServicio(id);
        return ResponseEntity.noContent().build();
    }
}
