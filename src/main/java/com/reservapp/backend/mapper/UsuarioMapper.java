package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.UsuarioDTO;
import com.reservapp.backend.model.Usuario;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UsuarioMapper {
    UsuarioDTO toDTO(Usuario usuario);
    Usuario toEntity(UsuarioDTO dto);
}
