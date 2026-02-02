import React, { createContext, useContext, useMemo, useState } from 'react';

interface DrawerContextValue {
    isOpen: boolean;
    openDrawer: () => void;
    closeDrawer: () => void;
    toggleDrawer: () => void;
}

const DrawerContext = createContext<DrawerContextValue | null>(null);

export function DrawerProvider({ children }: { children: React.ReactNode }) {
    const [isOpen, setIsOpen] = useState(false);

    const value = useMemo<DrawerContextValue>(() => {
        const openDrawer = () => setIsOpen(true);
        const closeDrawer = () => setIsOpen(false);
        const toggleDrawer = () => setIsOpen((prev) => !prev);
        return { isOpen, openDrawer, closeDrawer, toggleDrawer };
    }, [isOpen]);

    return <DrawerContext.Provider value={value}>{children}</DrawerContext.Provider>;
}

export function useDrawer() {
    const ctx = useContext(DrawerContext);
    if (!ctx) {
        throw new Error('useDrawer must be used within a DrawerProvider');
    }
    return ctx;
}

