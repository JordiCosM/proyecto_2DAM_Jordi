package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.HorarioDTO;
import com.reservapp.backend.model.Horario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface HorarioMapper {
    @Mapping(source = "empresa.id", target = "idEmpresa")
    HorarioDTO toDTO(Horario horario);

    @Mapping(target = "empresa", ignore = true)
    Horario toEntity(HorarioDTO dto);
}