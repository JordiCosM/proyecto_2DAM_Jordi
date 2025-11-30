package com.reservapp.backend.controller;

import com.reservapp.backend.dto.ProvinciaDTO;
import com.reservapp.backend.service.ProvinciaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/provincias")
public class ProvinciaController {
    private final ProvinciaService provinciaService;

    public ProvinciaController(ProvinciaService provinciaService) {
        this.provinciaService = provinciaService;
    }

    @GetMapping
    public ResponseEntity<List<ProvinciaDTO>> getAll() {
        return ResponseEntity.ok(provinciaService.listarProvincias());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProvinciaDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(provinciaService.obtenerProvinciaPorId(id));
    }
}
