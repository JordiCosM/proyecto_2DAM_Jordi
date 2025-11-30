package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.model.Servicio;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ServicioMapper {
    ServicioDTO toDTO(Servicio servicio);
    Servicio toEntity(ServicioDTO dto);
}
