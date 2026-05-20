package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.model.Empleado;
import com.reservapp.backend.model.Reserva;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import java.util.ArrayList;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ReservaMapper {
    @Mapping(source = "usuario.id", target = "idUsuario")
    @Mapping(source = "servicio.id", target = "idServicio")
    @Mapping(source = "empleados", target = "idEmpleados", qualifiedByName = "mapEmpleadoIds")
    ReservaDTO toDTO(Reserva reserva);

    @Mapping(target = "usuario", ignore = true)
    @Mapping(target = "servicio", ignore = true)
    @Mapping(target = "empleados", ignore = true)
    Reserva toEntity(ReservaDTO dto);

    @Named("mapEmpleadoIds")
    default List<Long> mapEmpleadoIds(List<Empleado> empleados) {
        if (empleados == null) return new ArrayList<>();
        return empleados.stream().map(Empleado::getId).toList();
    }
}