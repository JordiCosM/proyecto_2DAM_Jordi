package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.ReservaDTO;
import com.reservapp.backend.model.Reserva;
import com.reservapp.backend.model.Servicio;
import com.reservapp.backend.model.Usuario;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface ReservaMapper {
    @Mapping(source = "usuario", target = "idUsuario", qualifiedByName = "mapUsuarioId")
    @Mapping(source = "servicio", target = "idServicio", qualifiedByName = "mapServicioId")
    @Mapping(source = "estado", target = "estado", qualifiedByName = "mapEstadoToString")
    ReservaDTO toDTO(Reserva reserva);

    @Mapping(target = "usuario", source = "idUsuario", qualifiedByName = "mapIdToUsuario")
    @Mapping(target = "servicio", source = "idServicio", qualifiedByName = "mapIdToServicio")
    @Mapping(target = "estado", source = "estado", qualifiedByName = "mapStringToEstado")
    Reserva toEntity(ReservaDTO dto);

    @Named("mapUsuarioId")
    default Integer mapUsuarioId(Usuario usuario) {
        return usuario != null ? usuario.getId() : null;
    }

    @Named("mapServicioId")
    default Integer mapServicioId(Servicio servicio) {
        return servicio != null ? servicio.getId() : null;
    }

    @Named("mapIdToUsuario")
    default Usuario mapIdToUsuario(Integer idUsuario) {
        if (idUsuario == null) return null;
        Usuario usuario = new Usuario();
        usuario.setId(idUsuario);
        return usuario;
    }

    @Named("mapIdToServicio")
    default Servicio mapIdToServicio(Integer idServicio) {
        if (idServicio == null) return null;
        Servicio servicio = new Servicio();
        servicio.setId(idServicio);
        return servicio;
    }

    @Named("mapEstadoToString")
    default String mapEstadoToString(Reserva.Estado estado) {
        return estado != null ? estado.name() : null;
    }

    @Named("mapStringToEstado")
    default Reserva.Estado mapStringToEstado(String estado) {
        return estado != null ? Reserva.Estado.valueOf(estado) : Reserva.Estado.pendiente;
    }
}
