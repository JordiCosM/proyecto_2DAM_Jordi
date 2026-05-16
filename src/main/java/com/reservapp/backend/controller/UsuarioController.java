package com.reservapp.backend.controller;

import com.reservapp.backend.dto.CrearClienteRequest;
import com.reservapp.backend.dto.UsuarioDTO;
import com.reservapp.backend.service.UsuarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
@Tag(name = "Usuarios", description = "API de los usuarios")
public class UsuarioController {
    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CLIENTE', 'EMPRESA', 'BASICO', 'SUPERVISOR', 'ADMIN_EMPRESA')")
    @Operation(summary = "Obtener un usuario por id")
    public ResponseEntity<UsuarioDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(usuarioService.obtenerUsuarioPorId(id));
    }

    @GetMapping("/email/{email}")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'BASICO', 'ADMIN_EMPRESA', 'SUPERVISOR')")
    @Operation(summary = "Buscar usuario por email")
    public ResponseEntity<UsuarioDTO> getByEmail(@PathVariable String email) {
        return ResponseEntity.ok(usuarioService.obtenerUsuarioPorEmail(email));
    }

    @PostMapping("/cliente")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA', 'BASICO', 'ADMIN_EMPRESA', 'SUPERVISOR')")
    @Operation(summary = "Crear cliente sin contraseña")
    public ResponseEntity<UsuarioDTO> crearCliente(@Valid @RequestBody CrearClienteRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(usuarioService.crearCliente(request));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CLIENTE', 'EMPRESA')")
    @Operation(summary = "Actualizar un usuario")
    public ResponseEntity<UsuarioDTO> update(@PathVariable Long id, @Valid @RequestBody UsuarioDTO dto) {
        return ResponseEntity.ok(usuarioService.actualizarUsuario(id, dto));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Eliminar un usuario")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        usuarioService.eliminarUsuario(id);
        return ResponseEntity.noContent().build();
    }
}