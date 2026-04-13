package com.reservapp.backend.controller;

import com.reservapp.backend.dto.*;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.model.Empleado;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.EmpleadoRepository;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Auth", description = "Registro e inicio de sesión")
public class AuthController {
    private final AuthService authService;
    private final UsuarioRepository usuarioRepository;
    private final EmpleadoRepository empleadoRepository;

    public AuthController(AuthService authService, UsuarioRepository usuarioRepository, EmpleadoRepository empleadoRepository) {
        this.authService = authService;
        this.usuarioRepository = usuarioRepository;
        this.empleadoRepository = empleadoRepository;
    }

    @PostMapping("/login")
    @Operation(summary = "Iniciar sesión")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/register")
    @Operation(summary = "Registrar usuario")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/forgot-password")
    @Operation(summary = "Solicitar recuperación de contraseña")
    public ResponseEntity<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        authService.forgotPassword(request);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/reset-password")
    @Operation(summary = "Restablecer contraseña con token")
    public ResponseEntity<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/me")
    @Operation(summary = "Obtener datos del usuario o empleado autenticado")
    public ResponseEntity<AuthResponse> me(Authentication authentication) {
        String email = authentication.getName();

        Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(email);
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();
            return ResponseEntity.ok(new AuthResponse(null, usuario.getId(),
                    usuario.getNombre(), usuario.getEmail(),
                    usuario.getRol().name(), "USUARIO", null));
        }

        Empleado empleado = empleadoRepository.findByEmail(email).orElseThrow(() -> new ResourceNotFoundException("No encontrado"));
        return ResponseEntity.ok(new AuthResponse(null, empleado.getId(),
                empleado.getNombre(), empleado.getEmail(),
                empleado.getRol().name(), "EMPLEADO",
                empleado.getEmpresa().getId()));
    }
}