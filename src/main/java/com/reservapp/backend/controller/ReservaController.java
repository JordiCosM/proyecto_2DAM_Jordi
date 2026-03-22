package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.model.Reserva;
import com.reservapp.backend.service.ReservaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservas")
@Tag(name = "Reservas", description = "API de las reservas")
public class ReservaController {
    private final ReservaService reservaService;

    public ReservaController(ReservaService reservaService) {
        this.reservaService = reservaService;
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Listar todas las reservas")
    public ResponseEntity<List<ReservaDTO>> getAll() {
        return ResponseEntity.ok(reservaService.listarReservas());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CLIENTE', 'EMPRESA')")
    @Operation(summary = "Obtener una reserva por id")
    public ResponseEntity<ReservaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(reservaService.obtenerReservaPorId(id));
    }

    @GetMapping("/usuario/{idUsuario}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CLIENTE')")
    @Operation(summary = "Listar reservas de un usuario")
    public ResponseEntity<List<ReservaDTO>> getByUsuario(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(reservaService.listarReservasPorUsuario(idUsuario));
    }

    @GetMapping("/servicio/{idServicio}")
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPRESA')")
    @Operation(summary = "Listar reservas de un servicio")
    public ResponseEntity<List<ReservaDTO>> getByServicio(@PathVariable Long idServicio) {
        return ResponseEntity.ok(reservaService.listarReservasPorServicio(idServicio));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('CLIENTE', 'ADMIN')")
    @Operation(summary = "Crear una reserva")
    public ResponseEntity<ReservaDTO> create(@Valid @RequestBody ReservaDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(reservaService.crearReserva(dto));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('CLIENTE', 'ADMIN')")
    @Operation(summary = "Actualizar una reserva")
    public ResponseEntity<ReservaDTO> update(@PathVariable Long id, @Valid @RequestBody ReservaDTO dto) {
        return ResponseEntity.ok(reservaService.actualizarReserva(id, dto));
    }

    @PatchMapping("/{id}/estado")
    @PreAuthorize("hasAnyRole('EMPRESA', 'ADMIN')")
    @Operation(summary = "Cambiar el estado de una reserva")
    public ResponseEntity<ReservaDTO> cambiarEstado(@PathVariable Long id,
                                                    @RequestParam Reserva.Estado estado) {
        return ResponseEntity.ok(reservaService.cambiarEstado(id, estado));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('CLIENTE', 'ADMIN')")
    @Operation(summary = "Cancelar una reserva")
    public ResponseEntity<Void> cancelar(@PathVariable Long id) {
        reservaService.cancelarReserva(id);
        return ResponseEntity.noContent().build();
    }
}