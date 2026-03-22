package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.service.ServicioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    @Operation(summary = "Listar todos los servicios")
    public ResponseEntity<List<ServicioDTO>> getAll() {
        return ResponseEntity.ok(servicioService.listarServicios());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener un servicio por id")
    public ResponseEntity<ServicioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(servicioService.obtenerServicioPorId(id));
    }

    @GetMapping("/empresa/{idEmpresa}")
    @Operation(summary = "Listar servicios de una empresa")
    public ResponseEntity<List<ServicioDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(servicioService.listarServiciosPorEmpresa(idEmpresa));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN')")
    @Operation(summary = "Crear un servicio")
    public ResponseEntity<ServicioDTO> create(@Valid @RequestBody ServicioDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(servicioService.crearServicio(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN')")
    @Operation(summary = "Actualizar un servicio")
    public ResponseEntity<ServicioDTO> update(@PathVariable Long id, @Valid @RequestBody ServicioDTO dto) {
        return ResponseEntity.ok(servicioService.actualizarServicio(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN')")
    @Operation(summary = "Eliminar un servicio")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        servicioService.eliminarServicio(id);
        return ResponseEntity.noContent().build();
    }
}