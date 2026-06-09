(() => {
    const button = document.getElementById('profileMenuButton');
    const menu = document.getElementById('profileMenu');
    if (!button || !menu) return;

    const setOpen = (open) => {
        menu.hidden = !open;
        button.setAttribute('aria-expanded', String(open));
    };

    button.addEventListener('click', (e) => {
        e.stopPropagation();
        setOpen(menu.hidden);
    });

    document.addEventListener('click', (e) => {
        if (!menu.hidden && !menu.contains(e.target) && e.target !== button) {
            setOpen(false);
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') setOpen(false);
    });
})();