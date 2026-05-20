package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.UsuarioDTO;
import com.reservapp.backend.model.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    UsuarioDTO toDTO(Usuario usuario);

    @Mapping(target = "password", ignore = true)
    @Mapping(target = "empresas", ignore = true)
    @Mapping(target = "reservas", ignore = true)
    Usuario toEntity(UsuarioDTO dto);
}