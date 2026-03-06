package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.CiudadDTO;
import com.reservapp.backend.model.Ciudad;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CiudadMapper {
    @Mapping(source = "provincia.id", target = "idProvincia")
    CiudadDTO toDTO(Ciudad ciudad);

    Ciudad toEntity(CiudadDTO dto);
}
