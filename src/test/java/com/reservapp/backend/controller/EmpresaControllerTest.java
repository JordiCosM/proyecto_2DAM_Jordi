package com.reservapp.backend.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.reservapp.backend.config.FileStorageService;
import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.security.JwtAuthenticationFilter;
import com.reservapp.backend.security.JwtService;
import com.reservapp.backend.security.SecurityConfig;
import com.reservapp.backend.service.EmpresaService;
import com.reservapp.backend.service.UsuarioService;
import jakarta.servlet.FilterChain;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(EmpresaController.class)
@Import(SecurityConfig.class)
class EmpresaControllerTest {

    @Autowired
    MockMvc mockMvc;
    @Autowired
    ObjectMapper objectMapper;

    @MockitoBean
    EmpresaService empresaService;
    @MockitoBean
    FileStorageService fileStorageService;
    @MockitoBean
    JwtService jwtService;
    @MockitoBean
    UsuarioService usuarioService;
    @MockitoBean
    JwtAuthenticationFilter jwtAuthenticationFilter;
    @MockitoBean
    PasswordEncoder passwordEncoder;

    private EmpresaDTO empresaEjemplo() {
        EmpresaDTO dto = new EmpresaDTO();
        dto.setId(1L);
        dto.setIdUsuario(1L);
        dto.setIdCiudad(1L);
        dto.setNombre("Clínica Test");
        dto.setSector("Salud");
        dto.setEmail("clinica@test.com");
        dto.setTelefono("600000000");
        return dto;
    }

    @BeforeEach
    void configurarFiltroJwt() throws Exception {
        doAnswer(inv -> {
            FilterChain chain = inv.getArgument(2);
            chain.doFilter(inv.getArgument(0), inv.getArgument(1));
            return null;
        }).when(jwtAuthenticationFilter).doFilter(any(), any(), any());
    }

    // GET ALL
    @Test
    @WithMockUser
    void getAll_autenticado_retornaLista() throws Exception {
        when(empresaService.listarEmpresas()).thenReturn(List.of(empresaEjemplo()));

        mockMvc.perform(get("/api/empresas")).andExpect(status().isOk()).andExpect(jsonPath("$[0].nombre").value("Clínica Test")).andExpect(jsonPath("$[0].sector").value("Salud"));
    }

    @Test
    void getAll_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(get("/api/empresas")).andExpect(status().isForbidden());
    }

    // GET BY ID
    @Test
    @WithMockUser
    void getById_empresaExistente_retornaEmpresa() throws Exception {
        when(empresaService.obtenerEmpresaPorId(1L)).thenReturn(empresaEjemplo());

        mockMvc.perform(get("/api/empresas/1")).andExpect(status().isOk()).andExpect(jsonPath("$.id").value(1)).andExpect(jsonPath("$.nombre").value("Clínica Test")).andExpect(jsonPath("$.email").value("clinica@test.com"));
    }

    @Test
    @WithMockUser
    void getById_empresaNoExistente_retorna404() throws Exception {
        when(empresaService.obtenerEmpresaPorId(99L)).thenThrow(new ResourceNotFoundException("Empresa no encontrada"));

        mockMvc.perform(get("/api/empresas/99")).andExpect(status().isNotFound()).andExpect(jsonPath("$.message").value("Empresa no encontrada")).andExpect(jsonPath("$.status").value(404));
    }

    // GET BY USUARIO
    @Test
    @WithMockUser
    void getByUsuario_retornaEmpresasDelUsuario() throws Exception {
        when(empresaService.listarEmpresasPorUsuario(1L)).thenReturn(List.of(empresaEjemplo()));

        mockMvc.perform(get("/api/empresas/usuario/1")).andExpect(status().isOk()).andExpect(jsonPath("$[0].idUsuario").value(1)).andExpect(jsonPath("$[0].nombre").value("Clínica Test"));
    }

    // CREATE
    @Test
    @WithMockUser(roles = "EMPRESA")
    void create_conRolEmpresa_retorna201() throws Exception {
        EmpresaDTO dto = empresaEjemplo();
        when(empresaService.crearEmpresa(any(EmpresaDTO.class))).thenReturn(dto);

        mockMvc.perform(post("/api/empresas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(dto))).andExpect(status().isCreated()).andExpect(jsonPath("$.nombre").value("Clínica Test"));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void create_conRolCliente_retorna201() throws Exception {
        EmpresaDTO dto = empresaEjemplo();
        when(empresaService.crearEmpresa(any(EmpresaDTO.class))).thenReturn(dto);

        mockMvc.perform(post("/api/empresas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(dto))).andExpect(status().isCreated());
    }

    @Test
    void create_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(post("/api/empresas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(empresaEjemplo()))).andExpect(status().isForbidden());
    }

    // UPDATE
    @Test
    @WithMockUser(roles = "ADMIN")
    void update_conRolAdmin_retornaEmpresaActualizada() throws Exception {
        EmpresaDTO dto = empresaEjemplo();
        dto.setNombre("Clínica Actualizada");
        when(empresaService.actualizarEmpresa(eq(1L), any(EmpresaDTO.class))).thenReturn(dto);

        mockMvc.perform(put("/api/empresas/1").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(dto))).andExpect(status().isOk()).andExpect(jsonPath("$.nombre").value("Clínica Actualizada"));
    }

    // DELETE
    @Test
    @WithMockUser(roles = "ADMIN")
    void delete_conRolAdmin_retorna204() throws Exception {
        doNothing().when(empresaService).eliminarEmpresa(1L);

        mockMvc.perform(delete("/api/empresas/1")).andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void delete_conRolCliente_retorna403() throws Exception {
        mockMvc.perform(delete("/api/empresas/1")).andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void delete_empresaNoExistente_retorna404() throws Exception {
        doThrow(new ResourceNotFoundException("Empresa no encontrada")).when(empresaService).eliminarEmpresa(99L);

        mockMvc.perform(delete("/api/empresas/99")).andExpect(status().isNotFound());
    }
}