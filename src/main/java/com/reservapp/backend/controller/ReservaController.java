package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.service.ReservaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
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
    @Operation(summary = "Listar todas las reservas", description = "Listar todas las reservas")
    public ResponseEntity<List<ReservaDTO>> getAll() {
        return ResponseEntity.ok(reservaService.listarReservas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Recoger una reserva", description = "Recoger una reserva por su id")
    public ResponseEntity<ReservaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(reservaService.obtenerReservaPorId(id));
    }

    @GetMapping("/usuario/{idUsuario}")
    @Operation(summary = "Listar todas las reservas de un usuario", description = "Listar todas las reservas de un usuario por su id")
    public ResponseEntity<List<ReservaDTO>> getByUsuario(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(reservaService.listarReservasPorUsuario(idUsuario));
    }

    @GetMapping("/servicio/{idServicio}")
    @Operation(summary = "Listar todas las reservas de un servicio", description = "Listar todas las reservas de un servicio por su id")
    public ResponseEntity<List<ReservaDTO>> getByServicio(@PathVariable Long idServicio) {
        return ResponseEntity.ok(reservaService.listarReservasPorServicio(idServicio));
    }

    @PostMapping
    @Operation(summary = "Crear una reserva", description = "Crear una reserva")
    public ResponseEntity<ReservaDTO> create(@RequestBody ReservaDTO dto) {
        return ResponseEntity.ok(reservaService.crearReserva(dto));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar una reserva", description = "Actualizar una reserva por su id")
    public ResponseEntity<ReservaDTO> update(@PathVariable Long id, @RequestBody ReservaDTO dto) {
        return ResponseEntity.ok(reservaService.actualizarReserva(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar una reserva", description = "Eliminar una reserva por su id")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        reservaService.cancelarReserva(id);
        return ResponseEntity.noContent().build();
    }
}
