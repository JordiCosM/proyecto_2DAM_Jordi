package com.reservapp.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "ciudades")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Ciudad {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_provincia", nullable = false)
    private Provincia provincia;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 10)
    private String codPostal;

    @OneToMany(mappedBy = "ciudad")
    private List<Empresa> empresas;
}
