package com.reservapp.backend.controller;

import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.service.EmpresaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/empresas")
@Tag(name = "Empresas", description = "API de las empresas")
public class EmpresaController {
    private final EmpresaService empresaService;

    public EmpresaController(EmpresaService empresaService) {
        this.empresaService = empresaService;
    }

    @GetMapping
    @Operation(summary = "Listar todas las empresas", description = "Listar todas las empresas")
    public ResponseEntity<List<EmpresaDTO>> getAll() {
        return ResponseEntity.ok(empresaService.listarEmpresas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Recoger una empresa", description = "Recoger una empresa por su id")
    public ResponseEntity<EmpresaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(empresaService.obtenerEmpresaPorId(id));
    }

    @PostMapping
    @Operation(summary = "Crear una empresa", description = "Crear una empresa")
    public ResponseEntity<EmpresaDTO> create(@RequestBody EmpresaDTO dto) {
        return ResponseEntity.ok(empresaService.crearEmpresa(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar una empresa", description = "Actualizar una empresa por su id")
    public ResponseEntity<EmpresaDTO> update(@PathVariable Long id, @RequestBody EmpresaDTO dto) {
        return ResponseEntity.ok(empresaService.actualizarEmpresa(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar una empresa", description = "Eliminar una empresa por su id")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        empresaService.eliminarEmpresa(id);
        return ResponseEntity.noContent().build();
    }
}
