package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.model.Reserva;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ReservaMapper {
    @Mapping(source = "usuario.id", target = "idUsuario")
    @Mapping(source = "servicio.id", target = "idServicio")
    ReservaDTO toDTO(Reserva reserva);

    @Mapping(target = "usuario", ignore = true)
    @Mapping(target = "servicio", ignore = true)
    Reserva toEntity(ReservaDTO dto);
}