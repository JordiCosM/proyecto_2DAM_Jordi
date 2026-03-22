package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.AuthRequest;
import com.reservapp.backend.dto.AuthResponse;
import com.reservapp.backend.dto.RegisterRequest;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.model.Usuario;
import com.reservapp.backend.repository.UsuarioRepository;
import com.reservapp.backend.security.JwtService;
import com.reservapp.backend.service.AuthService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthServiceImpl implements AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthServiceImpl(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    @Override
    public AuthResponse login(AuthRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BadRequestException("Credenciales incorrectas"));

        if (!passwordEncoder.matches(request.getPassword(), usuario.getPassword())) {
            throw new BadRequestException("Credenciales incorrectas");
        }

        String token = jwtService.generateToken(usuario.getEmail());
        return new AuthResponse(token);
    }

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("El email ya está registrado");
        }

        if (request.getRol() == Usuario.Rol.ADMIN) {
            throw new BadRequestException("No puedes registrarte con ese rol");
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombre(request.getNombre());
        nuevo.setApellidos(request.getApellidos());
        nuevo.setEmail(request.getEmail());
        nuevo.setTelefono(request.getTelefono());
        nuevo.setPassword(passwordEncoder.encode(request.getPassword()));
        nuevo.setRol(request.getRol());

        usuarioRepository.save(nuevo);

        String token = jwtService.generateToken(nuevo.getEmail());
        return new AuthResponse(token);
    }
}