import '../../styles/perfil.css'

function PerfilCabecera({ usuario }) {
    return (
        <div className="d-flex align-items-center gap-3 mb-4">
            <div className="perfil-avatar">
                <i className="bi bi-person-fill" />
            </div>
            <div>
                <div className="perfil-nombre">{usuario?.nombre} {usuario?.apellidos}</div>
                <span className="perfil-rol-badge">{usuario?.rol}</span>
            </div>
        </div>
    )
}

export default PerfilCabecera