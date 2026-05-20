import { useState, useEffect, useRef } from 'react'
import '../../styles/home.css'

const ESTADOS = ['PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'FINALIZADA']

function DropdownEstado({ reserva, onCambiarEstado }) {
    const [abierto, setAbierto] = useState(false)
    const [pos, setPos] = useState({ top: 0, left: 0 })
    const badgeRef = useRef(null)
    const menuRef = useRef(null)

    const handleToggle = (e) => {
        e.stopPropagation()
        const rect = badgeRef.current.getBoundingClientRect()
        if (!abierto) {
            setPos({
                top: rect.bottom + window.scrollY + 4,
                left: Math.min(
                    rect.right + window.scrollX - 160,
                    window.innerWidth - 170
                ),
            })
        }
        setAbierto(!abierto)
    }

    useEffect(() => {
        if (!abierto) return
        const handleClick = (e) => {
            if (!menuRef.current?.contains(e.target) && !badgeRef.current?.contains(e.target)) {
                setAbierto(false)
            }
        }
        document.addEventListener('mousedown', handleClick)
        return () => document.removeEventListener('mousedown', handleClick)
    }, [abierto])

    return (
        <>
            <span
                ref={badgeRef}
                className={`estado-badge estado-${reserva.estado}`}
                style={{ cursor: 'pointer', userSelect: 'none' }}
                onClick={handleToggle}
            >
                {reserva.estado} <i className="bi bi-chevron-down" style={{ fontSize: '0.6rem' }} />
            </span>
            {abierto && (
                <ul
                    ref={menuRef}
                    className="dropdown-menu show"
                    style={{ position: 'fixed', top: pos.top, left: pos.left, zIndex: 9999, minWidth: 160 }}
                >
                    {ESTADOS.map((e) => (
                        <li key={e}>
                            <button
                                className="dropdown-item small"
                                disabled={e === reserva.estado}
                                onClick={() => { onCambiarEstado(reserva.id, e); setAbierto(false) }}
                            >
                                {e}
                            </button>
                        </li>
                    ))}
                </ul>
            )}
        </>
    )
}

export default DropdownEstado