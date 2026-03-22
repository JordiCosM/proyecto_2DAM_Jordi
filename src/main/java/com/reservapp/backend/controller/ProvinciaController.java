package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ProvinciaDTO;
import com.reservapp.backend.service.ProvinciaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/provincias")
@Tag(name = "Provincias", description = "API de las provincias")
public class ProvinciaController {
    private final ProvinciaService provinciaService;

    public ProvinciaController(ProvinciaService provinciaService) {
        this.provinciaService = provinciaService;
    }

    @GetMapping
    @Operation(summary = "Listar todas las provincias")
    public ResponseEntity<List<ProvinciaDTO>> getAll() {
        return ResponseEntity.ok(provinciaService.listarProvincias());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener una provincia por id")
    public ResponseEntity<ProvinciaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(provinciaService.obtenerProvinciaPorId(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Crear una provincia")
    public ResponseEntity<ProvinciaDTO> create(@Valid @RequestBody ProvinciaDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(provinciaService.crearProvincia(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Actualizar una provincia")
    public ResponseEntity<ProvinciaDTO> update(@PathVariable Long id, @Valid @RequestBody ProvinciaDTO dto) {
        return ResponseEntity.ok(provinciaService.actualizarProvincia(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar una provincia")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        provinciaService.eliminarProvincia(id);
        return ResponseEntity.noContent().build();
    }
}