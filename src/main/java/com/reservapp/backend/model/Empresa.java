package com.reservapp.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "empresas")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Empresa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_ciudad", nullable = false)
    private Ciudad ciudad;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(length = 255)
    private String direccion;

    @Column(length = 20)
    private String telefono;

    @Column(length = 150)
    private String email;

    @Column(length = 100)
    private String sector;

    @Column(length = 255)
    private String logoUrl;

    @OneToMany(mappedBy = "empresa", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Servicio> servicios = new ArrayList<>();

    @OneToMany(mappedBy = "empresa", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Horario> horarios = new ArrayList<>();

    @OneToMany(mappedBy = "empresa", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Empleado> empleados = new ArrayList<>();
}
