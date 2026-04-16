package com.reservapp.backend.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
public class PasswordResetService {

    private record TokenData(String email, LocalDateTime expiracion) {}

    private final Map<String, TokenData> tokens = new ConcurrentHashMap<>();
    private static final int MINUTOS_EXPIRACION = 15;

    public String generarToken(String email) {
        tokens.entrySet().removeIf(e -> e.getValue().email().equals(email));

        String token = UUID.randomUUID().toString();
        tokens.put(token, new TokenData(email, LocalDateTime.now().plusMinutes(MINUTOS_EXPIRACION)));

        log.info("=== TOKEN RECUPERACIÓN DE CONTRASEÑA ===");
        log.info("Email: {}", email);
        log.info("Token: {}", token);
        log.info("Expira en: {} minutos", MINUTOS_EXPIRACION);
        log.info("========================================");

        return token;
    }

    public String validarToken(String token) {
        TokenData data = tokens.get(token);

        if (data == null) {
            return null;
        }

        if (LocalDateTime.now().isAfter(data.expiracion())) {
            tokens.remove(token);
            return null;
        }

        return data.email();
    }

    public void invalidarToken(String token) {
        tokens.remove(token);
    }
}