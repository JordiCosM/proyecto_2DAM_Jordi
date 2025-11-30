package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.model.Horario;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface HorarioMapper {
    HorarioDTO toDTO(Horario horario);
    Horario toEntity(HorarioDTO dto);
}
