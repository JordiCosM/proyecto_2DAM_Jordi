package com.reservapp.backend.controller;

import com.reservapp.backend.dto.CiudadDTO;
import com.reservapp.backend.service.CiudadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ciudades")
@Tag(name = "Ciudades", description = "API de las ciudades")
public class CiudadController {
    private final CiudadService ciudadService;

    public CiudadController(CiudadService ciudadService) {
        this.ciudadService = ciudadService;
    }

    @GetMapping
    @Operation(summary = "Listar todas las ciudades")
    public ResponseEntity<List<CiudadDTO>> getAll() {
        return ResponseEntity.ok(ciudadService.listarCiudades());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener una ciudad por id")
    public ResponseEntity<CiudadDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(ciudadService.obtenerCiudadPorId(id));
    }

    @GetMapping("/provincia/{idProvincia}")
    @Operation(summary = "Listar ciudades de una provincia")
    public ResponseEntity<List<CiudadDTO>> getByProvincia(@PathVariable Long idProvincia) {
        return ResponseEntity.ok(ciudadService.listarCiudadesPorProvincia(idProvincia));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear una ciudad")
    public ResponseEntity<CiudadDTO> create(@Valid @RequestBody CiudadDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ciudadService.crearCiudad(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar una ciudad")
    public ResponseEntity<CiudadDTO> update(@PathVariable Long id, @Valid @RequestBody CiudadDTO dto) {
        return ResponseEntity.ok(ciudadService.actualizarCiudad(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una ciudad")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        ciudadService.eliminarCiudad(id);
        return ResponseEntity.noContent().build();
    }
}