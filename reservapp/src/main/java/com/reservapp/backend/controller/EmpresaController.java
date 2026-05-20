package com.reservapp.backend.controller;

import com.reservapp.backend.config.FileStorageService;
import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.service.EmpresaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/empresas")
@Tag(name = "Empresas", description = "API de las empresas")
public class EmpresaController {
    private final EmpresaService empresaService;
    private final FileStorageService fileStorageService;

    public EmpresaController(EmpresaService empresaService, FileStorageService fileStorageService) {
        this.empresaService = empresaService;
        this.fileStorageService = fileStorageService;
    }

    @GetMapping
    @Operation(summary = "Listar todas las empresas")
    public ResponseEntity<List<EmpresaDTO>> getAll() {
        return ResponseEntity.ok(empresaService.listarEmpresas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener una empresa por id")
    public ResponseEntity<EmpresaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(empresaService.obtenerEmpresaPorId(id));
    }

    @GetMapping("/usuario/{idUsuario}")
    @Operation(summary = "Listar empresas de un usuario")
    public ResponseEntity<List<EmpresaDTO>> getByUsuario(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(empresaService.listarEmpresasPorUsuario(idUsuario));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'CLIENTE')")
    @Operation(summary = "Crear una empresa")
    public ResponseEntity<EmpresaDTO> create(@Valid @RequestBody EmpresaDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(empresaService.crearEmpresa(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Actualizar una empresa")
    public ResponseEntity<EmpresaDTO> update(@PathVariable Long id, @Valid @RequestBody EmpresaDTO dto) {
        return ResponseEntity.ok(empresaService.actualizarEmpresa(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Eliminar una empresa")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        empresaService.eliminarEmpresa(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/logo")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Subir o reemplazar el logo")
    public ResponseEntity<EmpresaDTO> subirLogo(@PathVariable Long id, @RequestParam("file") MultipartFile file) throws IOException {

        EmpresaDTO actual = empresaService.obtenerEmpresaPorId(id);
        if (actual.getLogoUrl() != null) {
            fileStorageService.eliminar(actual.getLogoUrl());
        }

        String ruta = fileStorageService.guardar(file, "logos");
        return ResponseEntity.ok(empresaService.actualizarLogo(id, ruta));
    }

    @PostMapping("/{id}/imagenes")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Añadir una imagen a la galería")
    public ResponseEntity<EmpresaDTO> subirImagen(@PathVariable Long id, @RequestParam("file") MultipartFile file) throws IOException {

        String ruta = fileStorageService.guardar(file, "galeria");
        return ResponseEntity.ok(empresaService.agregarImagen(id, ruta));
    }

    @DeleteMapping("/{id}/imagenes")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN', 'ADMIN_EMPRESA')")
    @Operation(summary = "Eliminar una imagen de la galería")
    public ResponseEntity<EmpresaDTO> eliminarImagen(@PathVariable Long id, @RequestParam("url") String url) {

        fileStorageService.eliminar(url);
        return ResponseEntity.ok(empresaService.eliminarImagen(id, url));
    }
}