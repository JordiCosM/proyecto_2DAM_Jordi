package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ProvinciaDTO;
import com.reservapp.backend.model.Provincia;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ProvinciaMapper {
    ProvinciaDTO toDTO(Provincia provincia);
    Provincia toEntity(ProvinciaDTO dto);
}
