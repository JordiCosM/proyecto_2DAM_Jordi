package com.reservapp.backend.controller;

import com.reservapp.backend.dto.CreateEmpleadoRequest;
import com.reservapp.backend.dto.EmpleadoDTO;
import com.reservapp.backend.service.EmpleadoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/empleados")
@Tag(name = "Empleados", description = "API de empleados")
public class EmpleadoController {
    private final EmpleadoService empleadoService;

    public EmpleadoController(EmpleadoService empleadoService) {
        this.empleadoService = empleadoService;
    }

    @GetMapping("/empresa/{idEmpresa}")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA', 'SUPERVISOR')")
    @Operation(summary = "Listar empleados de una empresa")
    public ResponseEntity<List<EmpleadoDTO>> getByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(empleadoService.listarEmpleadosPorEmpresa(idEmpresa));
    }

    @GetMapping("/empresa/{idEmpresa}/activos")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA', 'SUPERVISOR')")
    @Operation(summary = "Listar empleados activos de una empresa")
    public ResponseEntity<List<EmpleadoDTO>> getActivosByEmpresa(@PathVariable Long idEmpresa) {
        return ResponseEntity.ok(empleadoService.listarEmpleadosActivosPorEmpresa(idEmpresa));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA', 'SUPERVISOR', 'BASICO')")
    @Operation(summary = "Obtener empleado por id")
    public ResponseEntity<EmpleadoDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(empleadoService.obtenerEmpleadoPorId(id));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA')")
    @Operation(summary = "Crear empleado")
    public ResponseEntity<EmpleadoDTO> create(@Valid @RequestBody CreateEmpleadoRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(empleadoService.crearEmpleado(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA')")
    @Operation(summary = "Actualizar empleado")
    public ResponseEntity<EmpleadoDTO> update(@PathVariable Long id, @Valid @RequestBody EmpleadoDTO dto) {
        return ResponseEntity.ok(empleadoService.actualizarEmpleado(id, dto));
    }

    @PatchMapping("/{id}/desactivar")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA')")
    @Operation(summary = "Desactivar empleado")
    public ResponseEntity<Void> desactivar(@PathVariable Long id) {
        empleadoService.desactivarEmpleado(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/activar")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'ADMIN_EMPRESA')")
    @Operation(summary = "Activar empleado")
    public ResponseEntity<Void> activar(@PathVariable Long id) {
        empleadoService.activarEmpleado(id);
        return ResponseEntity.noContent().build();
    }
}
