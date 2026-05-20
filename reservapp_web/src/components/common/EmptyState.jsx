function EmptyState({ icono, texto, children }) {
    return (
        <div className="empty-state">
            <i className={`bi ${icono}`} />
            <p>{texto}</p>
            {children}
        </div>
    )
}

export default EmptyState