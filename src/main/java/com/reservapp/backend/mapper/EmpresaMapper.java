package com.reservapp.backend.mapper;

import com.reservapp.backend.dto.EmpresaDTO;
import com.reservapp.backend.model.Empresa;
import com.reservapp.backend.model.Usuario;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface EmpresaMapper {
    EmpresaDTO toDTO(Empresa empresa);
    Empresa toEntity(EmpresaDTO dto);
}
