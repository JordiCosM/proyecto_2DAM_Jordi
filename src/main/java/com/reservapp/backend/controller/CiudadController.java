package com.reservapp.backend.controller;

import com.reservapp.backend.dto.CiudadDTO;
import com.reservapp.backend.service.CiudadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/ciudades")
@Tag(name = "Ciudades", description = "API de las ciudades")
public class CiudadController {
    private final CiudadService ciudadService;

    public CiudadController(CiudadService ciudadService) {
        this.ciudadService = ciudadService;
    }

    @GetMapping
    @Operation(summary = "Listar todas las ciudades", description = "Listar todas las ciudades")
    public ResponseEntity<List<CiudadDTO>> getAll() {
        return ResponseEntity.ok(ciudadService.listarCiudades());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Recoger una ciudad", description = "Recoger una ciudad por su id")
    public ResponseEntity<CiudadDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(ciudadService.obtenerCiudadPorId(id));
    }
}
