package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.model.Empresa;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface EmpresaMapper {
    @Mapping(source = "usuario.id", target = "idUsuario")
    @Mapping(source = "ciudad.id", target = "idCiudad")
    EmpresaDTO toDTO(Empresa empresa);

    Empresa toEntity(EmpresaDTO dto);
}
