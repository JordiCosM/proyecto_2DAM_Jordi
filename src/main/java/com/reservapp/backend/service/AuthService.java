package com.reservapp.backend.service;

import com.reservapp.backend.dto.AuthRequest;
import com.reservapp.backend.dto.AuthResponse;
import com.reservapp.backend.dto.RegisterRequest;

public interface AuthService {
    AuthResponse login(AuthRequest request);
    AuthResponse register(RegisterRequest request);
}