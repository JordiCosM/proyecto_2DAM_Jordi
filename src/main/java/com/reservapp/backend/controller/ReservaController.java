package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.service.ReservaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservas")
public class ReservaController {
    private final ReservaService reservaService;

    public ReservaController(ReservaService reservaService) {
        this.reservaService = reservaService;
    }

    @GetMapping
    public ResponseEntity<List<ReservaDTO>> getAll() {
        return ResponseEntity.ok(reservaService.listarReservas());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ReservaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(reservaService.obtenerReservaPorId(id));
    }

    @GetMapping("/usuario/{idUsuario}")
    public ResponseEntity<List<ReservaDTO>> getByUsuario(@PathVariable Long idUsuario) {
        return ResponseEntity.ok(reservaService.listarReservasPorUsuario(idUsuario));
    }

    @GetMapping("/servicio/{idServicio}")
    public ResponseEntity<List<ReservaDTO>> getByServicio(@PathVariable Long idServicio) {
        return ResponseEntity.ok(reservaService.listarReservasPorServicio(idServicio));
    }

    @PostMapping
    public ResponseEntity<ReservaDTO> create(@RequestBody ReservaDTO dto) {
        return ResponseEntity.ok(reservaService.crearReserva(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ReservaDTO> update(@PathVariable Long id, @RequestBody ReservaDTO dto) {
        return ResponseEntity.ok(reservaService.actualizarReserva(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        reservaService.cancelarReserva(id);
        return ResponseEntity.noContent().build();
    }
}
