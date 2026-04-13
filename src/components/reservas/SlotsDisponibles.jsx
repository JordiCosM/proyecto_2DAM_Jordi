import '../../styles/calendario.css'

function SlotsDisponibles({ slots, slotSeleccionado, onSelectSlot }) {
    if (!slots.length) {
        return <p className="text-muted small mt-2">No hay horarios disponibles para este día.</p>
    }

    return (
        <div className="slots-grid">
            {slots.map(({ hora, disponible }) => (
                <div
                    key={hora}
                    className={[
                        'slot-btn',
                        !disponible ? 'ocupado' : slotSeleccionado === hora ? 'seleccionado' : 'disponible',
                    ].join(' ')}
                    onClick={() => disponible && onSelectSlot(hora)}
                >
                    {hora}
                </div>
            ))}
        </div>
    )
}

export default SlotsDisponibles