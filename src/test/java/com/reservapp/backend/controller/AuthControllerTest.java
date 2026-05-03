package com.reservapp.backend.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.reservapp.backend.dto.*;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.EmpleadoRepository;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.security.JwtAuthenticationFilter;
import com.reservapp.backend.security.JwtService;
import com.reservapp.backend.security.SecurityConfig;
import com.reservapp.backend.service.AuthService;
import com.reservapp.backend.service.UsuarioService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
@Import(SecurityConfig.class)
class AuthControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;

    @MockitoBean AuthService authService;
    @MockitoBean UsuarioRepository usuarioRepository;
    @MockitoBean EmpleadoRepository empleadoRepository;
    @MockitoBean JwtService jwtService;
    @MockitoBean UsuarioService usuarioService;
    @MockitoBean JwtAuthenticationFilter jwtAuthenticationFilter;

    // LOGIN
    @Test
    void login_credencialesCorrectas_retorna200ConToken() throws Exception {
        AuthRequest request = new AuthRequest();
        request.setEmail("usuario@test.com");
        request.setPassword("password123");

        AuthResponse response = new AuthResponse(
                "jwt-token", 1L, "Usuario Test", "usuario@test.com", "CLIENTE", "USUARIO", null);
        when(authService.login(any(AuthRequest.class))).thenReturn(response);

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").value("jwt-token"))
                .andExpect(jsonPath("$.email").value("usuario@test.com"))
                .andExpect(jsonPath("$.rol").value("CLIENTE"))
                .andExpect(jsonPath("$.tipo").value("USUARIO"));
    }

    @Test
    void login_credencialesIncorrectas_retorna400() throws Exception {
        AuthRequest request = new AuthRequest();
        request.setEmail("usuario@test.com");
        request.setPassword("wrongpassword");

        when(authService.login(any(AuthRequest.class)))
                .thenThrow(new BadRequestException("Credenciales incorrectas"));

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Credenciales incorrectas"));
    }

    @Test
    void login_emailInvalido_retorna400DeValidacion() throws Exception {
        AuthRequest request = new AuthRequest();
        request.setEmail("esto-no-es-un-email");
        request.setPassword("password123");

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void login_camposVacios_retorna400DeValidacion() throws Exception {
        AuthRequest request = new AuthRequest();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    // REGISTER
    @Test
    void register_datosValidos_retorna200ConToken() throws Exception {
        RegisterRequest request = new RegisterRequest();
        request.setNombre("Juan García");
        request.setEmail("juan@test.com");
        request.setPassword("password123");
        request.setRol(Usuario.Rol.CLIENTE);

        AuthResponse response = new AuthResponse(
                "nuevo-token", 2L, "Juan García", "juan@test.com", "CLIENTE", "USUARIO", null);
        when(authService.register(any(RegisterRequest.class))).thenReturn(response);

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").value("nuevo-token"))
                .andExpect(jsonPath("$.nombre").value("Juan García"))
                .andExpect(jsonPath("$.rol").value("CLIENTE"));
    }

    @Test
    void register_emailYaRegistrado_retorna400() throws Exception {
        RegisterRequest request = new RegisterRequest();
        request.setNombre("Juan García");
        request.setEmail("juan@test.com");
        request.setPassword("password123");
        request.setRol(Usuario.Rol.CLIENTE);

        when(authService.register(any(RegisterRequest.class)))
                .thenThrow(new BadRequestException("El email ya está registrado"));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("El email ya está registrado"));
    }

    @Test
    void register_passwordCorta_retorna400DeValidacion() throws Exception {
        RegisterRequest request = new RegisterRequest();
        request.setNombre("Juan García");
        request.setEmail("juan@test.com");
        request.setPassword("corta");
        request.setRol(Usuario.Rol.CLIENTE);

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    // ME
    @Test
    @WithMockUser(username = "usuario@test.com")
    void me_usuarioAutenticado_retornaDatosDelUsuario() throws Exception {
        Usuario usuario = new Usuario();
        usuario.setId(1L);
        usuario.setNombre("Usuario Test");
        usuario.setEmail("usuario@test.com");
        usuario.setRol(Usuario.Rol.CLIENTE);

        when(usuarioRepository.findByEmail("usuario@test.com")).thenReturn(Optional.of(usuario));

        mockMvc.perform(get("/api/auth/me"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("usuario@test.com"))
                .andExpect(jsonPath("$.nombre").value("Usuario Test"))
                .andExpect(jsonPath("$.tipo").value("USUARIO"));
    }

    @Test
    void me_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(get("/api/auth/me"))
                .andExpect(status().isUnauthorized());
    }
}