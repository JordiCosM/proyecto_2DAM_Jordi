package com.reservapp.backend.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.reservapp.backend.dto.CreateEmpleadoRequest;
import com.reservapp.backend.dto.EmpleadoDTO;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.model.Empleado;
import com.reservapp.backend.security.JwtAuthenticationFilter;
import com.reservapp.backend.security.JwtService;
import com.reservapp.backend.security.SecurityConfig;
import com.reservapp.backend.service.EmpleadoService;
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

@WebMvcTest(EmpleadoController.class)
@Import(SecurityConfig.class)
class EmpleadoControllerTest {

    @Autowired
    MockMvc mockMvc;
    @Autowired
    ObjectMapper objectMapper;

    @MockitoBean
    EmpleadoService empleadoService;
    @MockitoBean
    JwtService jwtService;
    @MockitoBean
    UsuarioService usuarioService;
    @MockitoBean
    JwtAuthenticationFilter jwtAuthenticationFilter;
    @MockitoBean
    PasswordEncoder passwordEncoder;

    private EmpleadoDTO empleadoEjemplo() {
        EmpleadoDTO dto = new EmpleadoDTO();
        dto.setId(1L);
        dto.setIdEmpresa(1L);
        dto.setNombre("Ana López");
        dto.setApellidos("López García");
        dto.setEmail("ana@empresa.com");
        dto.setTelefono("611222333");
        dto.setRol(Empleado.Rol.BASICO);
        dto.setActivo(true);
        return dto;
    }

    private CreateEmpleadoRequest createRequestEjemplo() {
        CreateEmpleadoRequest request = new CreateEmpleadoRequest();
        request.setIdEmpresa(1L);
        request.setNombre("Ana López");
        request.setApellidos("López García");
        request.setEmail("ana@empresa.com");
        request.setPassword("password123");
        request.setTelefono("611222333");
        request.setRol(Empleado.Rol.BASICO);
        return request;
    }

    @BeforeEach
    void configurarFiltroJwt() throws Exception {
        doAnswer(inv -> {
            FilterChain chain = inv.getArgument(2);
            chain.doFilter(inv.getArgument(0), inv.getArgument(1));
            return null;
        }).when(jwtAuthenticationFilter).doFilter(any(), any(), any());
    }

    // GET BY EMPRESA
    @Test
    @WithMockUser(roles = "ADMIN")
    void getByEmpresa_conRolAdmin_retornaLista() throws Exception {
        when(empleadoService.listarEmpleadosPorEmpresa(1L)).thenReturn(List.of(empleadoEjemplo()));

        mockMvc.perform(get("/api/empleados/empresa/1")).andExpect(status().isOk()).andExpect(jsonPath("$[0].nombre").value("Ana López")).andExpect(jsonPath("$[0].email").value("ana@empresa.com")).andExpect(jsonPath("$[0].activo").value(true));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void getByEmpresa_sinRolAdecuado_retorna403() throws Exception {
        mockMvc.perform(get("/api/empleados/empresa/1")).andExpect(status().isForbidden());
    }

    @Test
    void getByEmpresa_sinAutenticar_retorna403() throws Exception {
        mockMvc.perform(get("/api/empleados/empresa/1")).andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void getActivosByEmpresa_retornaSoloActivos() throws Exception {
        when(empleadoService.listarEmpleadosActivosPorEmpresa(1L)).thenReturn(List.of(empleadoEjemplo()));

        mockMvc.perform(get("/api/empleados/empresa/1/activos")).andExpect(status().isOk()).andExpect(jsonPath("$[0].activo").value(true));
    }

    // GET BY ID
    @Test
    @WithMockUser(roles = "ADMIN")
    void getById_empleadoExistente_retornaEmpleado() throws Exception {
        when(empleadoService.obtenerEmpleadoPorId(1L)).thenReturn(empleadoEjemplo());

        mockMvc.perform(get("/api/empleados/1")).andExpect(status().isOk()).andExpect(jsonPath("$.id").value(1)).andExpect(jsonPath("$.nombre").value("Ana López")).andExpect(jsonPath("$.rol").value("BASICO"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void getById_empleadoNoExistente_retorna404() throws Exception {
        when(empleadoService.obtenerEmpleadoPorId(99L)).thenThrow(new ResourceNotFoundException("Empleado no encontrado"));

        mockMvc.perform(get("/api/empleados/99")).andExpect(status().isNotFound()).andExpect(jsonPath("$.message").value("Empleado no encontrado")).andExpect(jsonPath("$.status").value(404));
    }

    // CREATE
    @Test
    @WithMockUser(roles = "ADMIN")
    void create_datosValidos_retorna201() throws Exception {
        when(empleadoService.crearEmpleado(any(CreateEmpleadoRequest.class))).thenReturn(empleadoEjemplo());

        mockMvc.perform(post("/api/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(createRequestEjemplo()))).andExpect(status().isCreated()).andExpect(jsonPath("$.nombre").value("Ana López")).andExpect(jsonPath("$.email").value("ana@empresa.com")).andExpect(jsonPath("$.rol").value("BASICO"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void create_emailDuplicado_retorna400() throws Exception {
        when(empleadoService.crearEmpleado(any(CreateEmpleadoRequest.class))).thenThrow(new BadRequestException("El email ya está registrado"));

        mockMvc.perform(post("/api/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(createRequestEjemplo()))).andExpect(status().isBadRequest()).andExpect(jsonPath("$.message").value("El email ya está registrado"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void create_empresaNoExistente_retorna404() throws Exception {
        when(empleadoService.crearEmpleado(any(CreateEmpleadoRequest.class))).thenThrow(new ResourceNotFoundException("Empresa no encontrada"));

        mockMvc.perform(post("/api/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(createRequestEjemplo()))).andExpect(status().isNotFound()).andExpect(jsonPath("$.message").value("Empresa no encontrada"));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void create_passwordCorta_retorna400DeValidacion() throws Exception {
        CreateEmpleadoRequest request = createRequestEjemplo();
        request.setPassword("corta");

        mockMvc.perform(post("/api/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(request))).andExpect(status().isBadRequest());
    }

    @Test
    void create_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(post("/api/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(createRequestEjemplo()))).andExpect(status().isForbidden());
    }

    // UPDATE
    @Test
    @WithMockUser(roles = "ADMIN")
    void update_datosValidos_retornaEmpleadoActualizado() throws Exception {
        EmpleadoDTO dto = empleadoEjemplo();
        dto.setNombre("Ana Actualizada");
        when(empleadoService.actualizarEmpleado(eq(1L), any(EmpleadoDTO.class))).thenReturn(dto);

        mockMvc.perform(put("/api/empleados/1").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(dto))).andExpect(status().isOk()).andExpect(jsonPath("$.nombre").value("Ana Actualizada"));
    }

    // DESACTIVAR / ACTIVAR
    @Test
    @WithMockUser(roles = "ADMIN")
    void desactivar_empleadoExistente_retorna204() throws Exception {
        doNothing().when(empleadoService).desactivarEmpleado(1L);

        mockMvc.perform(patch("/api/empleados/1/desactivar")).andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void activar_empleadoExistente_retorna204() throws Exception {
        doNothing().when(empleadoService).activarEmpleado(1L);

        mockMvc.perform(patch("/api/empleados/1/activar")).andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void desactivar_sinRolAdecuado_retorna403() throws Exception {
        mockMvc.perform(patch("/api/empleados/1/desactivar")).andExpect(status().isForbidden());
    }
}