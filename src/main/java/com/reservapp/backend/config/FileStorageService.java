package com.reservapp.backend.config;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.UUID;

@Service
public class FileStorageService {

    private final Path raiz = Paths.get("uploads");

    @PostConstruct
    public void init() throws IOException {
        Files.createDirectories(raiz.resolve("logos"));
        Files.createDirectories(raiz.resolve("galeria"));
    }

    public String guardar(MultipartFile file, String carpeta) throws IOException {
        String extension = StringUtils.getFilenameExtension(file.getOriginalFilename());
        String nombreArchivo = UUID.randomUUID() + "." + extension;
        Path destino = raiz.resolve(carpeta).resolve(nombreArchivo);
        Files.copy(file.getInputStream(), destino, StandardCopyOption.REPLACE_EXISTING);
        return "/uploads/" + carpeta + "/" + nombreArchivo;
    }

    public void eliminar(String rutaRelativa) {
        if (rutaRelativa == null || rutaRelativa.isBlank()) return;
        try {
            Path archivo = Paths.get(rutaRelativa.substring(1));
            Files.deleteIfExists(archivo);
        } catch (IOException ignored) {
        }
    }
}