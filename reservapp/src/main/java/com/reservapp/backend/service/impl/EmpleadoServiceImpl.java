package com.reservapp.backend.service.impl;

import com.reservapp.backend.dto.CreateEmpleadoRequest;
import com.reservapp.backend.dto.EmpleadoDTO;
import com.reservapp.backend.exception.BadRequestException;
import com.reservapp.backend.exception.ResourceNotFoundException;
import com.reservapp.backend.mapper.EmpleadoMapper;
import com.reservapp.backend.model.Empleado;
import com.reservapp.backend.model.Empresa;
import com.reservapp.backend.repository.EmpleadoRepository;
import com.reservapp.backend.repository.EmpresaRepository;
import com.reservapp.backend.service.EmpleadoService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class EmpleadoServiceImpl implements EmpleadoService {
    private final EmpleadoRepository empleadoRepository;
    private final EmpresaRepository empresaRepository;
    private final EmpleadoMapper empleadoMapper;
    private final PasswordEncoder passwordEncoder;

    public EmpleadoServiceImpl(EmpleadoRepository empleadoRepository, EmpresaRepository empresaRepository, EmpleadoMapper empleadoMapper, PasswordEncoder passwordEncoder) {
        this.empleadoRepository = empleadoRepository;
        this.empresaRepository = empresaRepository;
        this.empleadoMapper = empleadoMapper;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public EmpleadoDTO crearEmpleado(CreateEmpleadoRequest request) {
        if (empleadoRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("El email ya está registrado");
        }

        Empresa empresa = empresaRepository.findById(request.getIdEmpresa()).orElseThrow(() -> new ResourceNotFoundException("Empresa no encontrada"));

        Empleado empleado = Empleado.builder()
                .empresa(empresa)
                .nombre(request.getNombre())
                .apellidos(request.getApellidos())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .telefono(request.getTelefono())
                .rol(request.getRol())
                .activo(true)
                .build();

        return empleadoMapper.toDTO(empleadoRepository.save(empleado));
    }

    @Override
    @Transactional
    public EmpleadoDTO actualizarEmpleado(Long id, EmpleadoDTO dto) {
        Empleado empleado = empleadoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empleado no encontrado"));

        empleado.setNombre(dto.getNombre());
        empleado.setApellidos(dto.getApellidos());
        empleado.setEmail(dto.getEmail());
        empleado.setTelefono(dto.getTelefono());
        empleado.setRol(dto.getRol());

        return empleadoMapper.toDTO(empleadoRepository.save(empleado));
    }

    @Override
    public EmpleadoDTO obtenerEmpleadoPorId(Long id) {
        Empleado empleado = empleadoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empleado no encontrado"));
        return empleadoMapper.toDTO(empleado);
    }

    @Override
    public List<EmpleadoDTO> listarEmpleadosPorEmpresa(Long idEmpresa) {
        return empleadoRepository.findByEmpresaId(idEmpresa).stream().map(empleadoMapper::toDTO).toList();
    }

    @Override
    public List<EmpleadoDTO> listarEmpleadosActivosPorEmpresa(Long idEmpresa) {
        return empleadoRepository.findByEmpresaIdAndActivo(idEmpresa, true).stream().map(empleadoMapper::toDTO).toList();
    }

    @Override
    @Transactional
    public void desactivarEmpleado(Long id) {
        Empleado empleado = empleadoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empleado no encontrado"));
        empleado.setActivo(false);
        empleadoRepository.save(empleado);
    }

    @Override
    @Transactional
    public void activarEmpleado(Long id) {
        Empleado empleado = empleadoRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Empleado no encontrado"));
        empleado.setActivo(true);
        empleadoRepository.save(empleado);
    }
}
