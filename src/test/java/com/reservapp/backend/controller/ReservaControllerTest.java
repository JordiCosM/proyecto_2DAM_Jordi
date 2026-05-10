package com.reservapp.backend.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.model.Reserva;
import com.reservapp.backend.security.JwtAuthenticationFilter;
import com.reservapp.backend.security.JwtService;
import com.reservapp.backend.security.SecurityConfig;
import com.reservapp.backend.service.ReservaService;
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

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(ReservaController.class)
@Import(SecurityConfig.class)
class ReservaControllerTest {

    @Autowired
    MockMvc mockMvc;
    @Autowired
    ObjectMapper objectMapper;

    @MockitoBean
    ReservaService reservaService;
    @MockitoBean
    JwtService jwtService;
    @MockitoBean
    UsuarioService usuarioService;
    @MockitoBean
    JwtAuthenticationFilter jwtAuthenticationFilter;
    @MockitoBean
    PasswordEncoder passwordEncoder;

    private ReservaDTO reservaEjemplo() {
        ReservaDTO dto = new ReservaDTO();
        dto.setId(1L);
        dto.setIdUsuario(1L);
        dto.setIdServicio(1L);
        dto.setFecha(LocalDate.of(2026, 6, 15));
        dto.setHoraInicio(LocalTime.of(10, 0));
        dto.setHoraFin(LocalTime.of(11, 0));
        dto.setEstado(Reserva.Estado.PENDIENTE);
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

    // GET ALL (ADMIN)
    @Test
    @WithMockUser(roles = "ADMIN")
    void getAll_conRolAdmin_retornaLista() throws Exception {
        when(reservaService.listarReservas()).thenReturn(List.of(reservaEjemplo()));

        mockMvc.perform(get("/api/reservas")).andExpect(status().isOk()).andExpect(jsonPath("$[0].idUsuario").value(1)).andExpect(jsonPath("$[0].estado").value("PENDIENTE"));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void getAll_sinRolAdmin_retorna403() throws Exception {
        mockMvc.perform(get("/api/reservas")).andExpect(status().isForbidden());
    }

    @Test
    void getAll_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(get("/api/reservas")).andExpect(status().isForbidden());
    }

    // GET BY ID
    @Test
    @WithMockUser(roles = "CLIENTE")
    void getById_reservaExistente_retornaReserva() throws Exception {
        when(reservaService.obtenerReservaPorId(1L)).thenReturn(reservaEjemplo());

        mockMvc.perform(get("/api/reservas/1")).andExpect(status().isOk()).andExpect(jsonPath("$.id").value(1)).andExpect(jsonPath("$.idServicio").value(1)).andExpect(jsonPath("$.estado").value("PENDIENTE"));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void getById_reservaNoExistente_retorna404() throws Exception {
        when(reservaService.obtenerReservaPorId(99L)).thenThrow(new ResourceNotFoundException("Reserva no encontrada"));

        mockMvc.perform(get("/api/reservas/99")).andExpect(status().isNotFound()).andExpect(jsonPath("$.message").value("Reserva no encontrada")).andExpect(jsonPath("$.status").value(404));
    }

    // GET BY USUARIO
    @Test
    @WithMockUser(roles = "CLIENTE")
    void getByUsuario_retornaReservasDelUsuario() throws Exception {
        when(reservaService.listarReservasPorUsuario(1L)).thenReturn(List.of(reservaEjemplo()));

        mockMvc.perform(get("/api/reservas/usuario/1")).andExpect(status().isOk()).andExpect(jsonPath("$[0].idUsuario").value(1));
    }

    // CREATE
    @Test
    @WithMockUser(roles = "CLIENTE")
    void create_conDisponibilidad_retorna201() throws Exception {
        ReservaDTO dto = reservaEjemplo();
        when(reservaService.crearReserva(any(ReservaDTO.class))).thenReturn(dto);

        mockMvc.perform(post("/api/reservas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(dto))).andExpect(status().isCreated()).andExpect(jsonPath("$.idServicio").value(1)).andExpect(jsonPath("$.estado").value("PENDIENTE"));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void create_sinDisponibilidad_retorna400() throws Exception {
        when(reservaService.crearReserva(any(ReservaDTO.class))).thenThrow(new BadRequestException("No hay disponibilidad para ese servicio en la franja horaria seleccionada"));

        mockMvc.perform(post("/api/reservas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(reservaEjemplo()))).andExpect(status().isBadRequest()).andExpect(jsonPath("$.message").value("No hay disponibilidad para ese servicio en la franja horaria seleccionada"));
    }

    @Test
    void create_sinAutenticar_retorna401() throws Exception {
        mockMvc.perform(post("/api/reservas").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(reservaEjemplo()))).andExpect(status().isForbidden());
        ;
    }

    // CAMBIAR ESTADO
    @Test
    @WithMockUser(roles = "EMPRESA")
    void cambiarEstado_conRolEmpresa_retornaReservaActualizada() throws Exception {
        ReservaDTO dto = reservaEjemplo();
        dto.setEstado(Reserva.Estado.CONFIRMADA);

        when(reservaService.cambiarEstado(eq(1L), eq(Reserva.Estado.CONFIRMADA))).thenReturn(dto);

        mockMvc.perform(patch("/api/reservas/1/estado").param("estado", "CONFIRMADA")).andExpect(status().isOk()).andExpect(jsonPath("$.estado").value("CONFIRMADA"));
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void cambiarEstado_conRolCliente_retorna403() throws Exception {
        mockMvc.perform(patch("/api/reservas/1/estado").param("estado", "CONFIRMADA")).andExpect(status().isForbidden());
    }

    // CANCELAR
    @Test
    @WithMockUser(roles = "CLIENTE")
    void cancelar_conRolCliente_retorna204() throws Exception {
        doNothing().when(reservaService).cancelarReserva(1L);

        mockMvc.perform(delete("/api/reservas/1")).andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser(roles = "CLIENTE")
    void cancelar_reservaNoExistente_retorna404() throws Exception {
        doThrow(new ResourceNotFoundException("Reserva no encontrada")).when(reservaService).cancelarReserva(99L);

        mockMvc.perform(delete("/api/reservas/99")).andExpect(status().isNotFound());
    }

    // ASIGNAR EMPLEADOS
    @Test
    @WithMockUser(roles = "SUPERVISOR")
    void asignarEmpleados_conRolSupervisor_retornaReservaActualizada() throws Exception {
        ReservaDTO dto = reservaEjemplo();
        dto.setIdEmpleados(List.of(1L, 2L));

        when(reservaService.asignarEmpleados(eq(1L), any())).thenReturn(dto);

        mockMvc.perform(post("/api/reservas/1/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(List.of(1L, 2L)))).andExpect(status().isOk()).andExpect(jsonPath("$.idEmpleados[0]").value(1));
    }

    @Test
    @WithMockUser(roles = "SUPERVISOR")
    void asignarEmpleados_empleadoDeOtraEmpresa_retorna400() throws Exception {
        when(reservaService.asignarEmpleados(eq(1L), any())).thenThrow(new BadRequestException("El empleado 5 no pertenece a la empresa de esta reserva"));

        mockMvc.perform(post("/api/reservas/1/empleados").contentType(MediaType.APPLICATION_JSON).content(objectMapper.writeValueAsString(List.of(5L)))).andExpect(status().isBadRequest()).andExpect(jsonPath("$.message").value("El empleado 5 no pertenece a la empresa de esta reserva"));
    }
}