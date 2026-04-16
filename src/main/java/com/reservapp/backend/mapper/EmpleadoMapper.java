package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.EmpleadoDTO;
import com.reservapp.backend.model.Empleado;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface EmpleadoMapper {
    @Mapping(source = "empresa.id", target = "idEmpresa")
    EmpleadoDTO toDTO(Empleado empleado);

    @Mapping(target = "empresa", ignore = true)
    @Mapping(target = "password", ignore = true)
    Empleado toEntity(EmpleadoDTO dto);
}
