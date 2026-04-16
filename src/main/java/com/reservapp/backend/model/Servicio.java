package com.reservapp.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "servicios")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Servicio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_empresa", nullable = false)
    private Empresa empresa;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(nullable = false)
    private Integer duracion; // minutos

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal precio;

    @OneToMany(mappedBy = "servicio")
    private List<Reserva> reservas = new ArrayList<>();

    @Column(nullable = false, columnDefinition = "INT DEFAULT 1")
    private Integer capacidad = 1;
}
