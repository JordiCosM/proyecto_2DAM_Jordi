package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ServicioDTO;
import com.reservapp.backend.model.Servicio;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ServicioMapper {
    @Mapping(source = "empresa.id", target = "idEmpresa")
    ServicioDTO toDTO(Servicio servicio);

    Servicio toEntity(ServicioDTO dto);
}
