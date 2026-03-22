package com.reservapp.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "ciudades")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Ciudad {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_provincia", nullable = false)
    private Provincia provincia;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 10)
    private String codPostal;

    @OneToMany(mappedBy = "ciudad")
    private List<Empresa> empresas = new ArrayList<>();
}
