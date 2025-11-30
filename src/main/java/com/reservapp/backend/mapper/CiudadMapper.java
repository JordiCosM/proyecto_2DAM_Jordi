package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.CiudadDTO;
import com.reservapp.backend.model.Ciudad;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CiudadMapper {
    CiudadDTO toDTO(Ciudad ciudad);
    Ciudad toEntity(CiudadDTO dto);
}
