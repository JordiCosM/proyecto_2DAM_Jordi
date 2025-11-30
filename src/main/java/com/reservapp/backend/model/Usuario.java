package com.reservapp.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "usuarios")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 150)
    private String apellidos;

    @Column(nullable = false, length = 150, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(length = 20)
    private String telefono;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "ENUM('cliente','empresa','admin') default 'cliente'")
    private Rol rol;

    @OneToMany(mappedBy = "usuario")
    private List<Empresa> empresas;

    @OneToMany(mappedBy = "usuario")
    private List<Reserva> reservas;

    public enum Rol {
        cliente, empresa, admin
    }
}
