import React, { createContext, useContext, useMemo, useState } from 'react';

interface PrayerSettingsContextValue {
    showUpcomingPrayerTimes: boolean;
    enablePrayerTimeNotifications: boolean;
    setShowUpcomingPrayerTimes: (value: boolean) => void;
    setEnablePrayerTimeNotifications: (value: boolean) => void;
    toggleShowUpcomingPrayerTimes: () => void;
    toggleEnablePrayerTimeNotifications: () => void;
}

const PrayerSettingsContext = createContext<PrayerSettingsContextValue | null>(null);

export function PrayerSettingsProvider({ children }: { children: React.ReactNode }) {
    const [showUpcomingPrayerTimes, setShowUpcomingPrayerTimesState] = useState(false);
    const [enablePrayerTimeNotifications, setEnablePrayerTimeNotificationsState] = useState(false);

    const value = useMemo<PrayerSettingsContextValue>(() => {
        const setShowUpcomingPrayerTimes = (next: boolean) => {
            setShowUpcomingPrayerTimesState(next);
            if (!next) {
                setEnablePrayerTimeNotificationsState(false);
            }
        };

        const setEnablePrayerTimeNotifications = (next: boolean) => {
            setEnablePrayerTimeNotificationsState(next);
        };

        const toggleShowUpcomingPrayerTimes = () => setShowUpcomingPrayerTimes(!showUpcomingPrayerTimes);

        const toggleEnablePrayerTimeNotifications = () => {
            if (!showUpcomingPrayerTimes) return;
            setEnablePrayerTimeNotifications(!enablePrayerTimeNotifications);
        };

        return {
            showUpcomingPrayerTimes,
            enablePrayerTimeNotifications,
            setShowUpcomingPrayerTimes,
            setEnablePrayerTimeNotifications,
            toggleShowUpcomingPrayerTimes,
            toggleEnablePrayerTimeNotifications,
        };
    }, [enablePrayerTimeNotifications, showUpcomingPrayerTimes]);

    return <PrayerSettingsContext.Provider value={value}>{children}</PrayerSettingsContext.Provider>;
}

export function usePrayerSettings() {
    const ctx = useContext(PrayerSettingsContext);
    if (!ctx) {
        throw new Error('usePrayerSettings must be used within a PrayerSettingsProvider');
    }
    return ctx;
}

