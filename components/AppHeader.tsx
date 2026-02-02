import React from 'react';
import { View, Text, TouchableOpacity, Image, StyleSheet, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../context/ThemeContext';
import { useDrawer } from '../context/DrawerContext';

interface AppHeaderProps {
    showMenu?: boolean;
    showNotification?: boolean;
    showLogo?: boolean;
    showLogout?: boolean; // Changed from showAvatar
    title?: string;
    showBack?: boolean;
}

export default function AppHeader({
    showMenu = true,
    showNotification = true,
    showLogo = true,
    showLogout = true, // Default to true for logout
    title,
    showBack = false
}: AppHeaderProps) {
    const router = useRouter();
    const { isDark } = useTheme();
    const { openDrawer } = useDrawer();

    const bgColor = isDark ? '#1F2937' : 'white';
    const iconColor = isDark ? '#60A5FA' : '#2563EB';
    const borderColor = isDark ? '#374151' : '#F5F5F5';

    const handleLogout = () => {
        Alert.alert('Logout', 'Are you sure you want to logout?', [
            { text: 'Cancel', style: 'cancel' },
            { text: 'Logout', style: 'destructive', onPress: () => router.replace('/login' as any) },
        ]);
    };

    return (
        <View style={[styles.header, { backgroundColor: bgColor, borderBottomColor: borderColor }]}>
            {/* Left Side */}
            <View style={styles.headerLeft}>
                {showBack ? (
                    <TouchableOpacity onPress={() => router.back()} style={[styles.iconButton, { backgroundColor: isDark ? '#374151' : '#F5F5F5' }]}>
                        <Ionicons name="arrow-back" size={22} color={iconColor} />
                    </TouchableOpacity>
                ) : showMenu && (
                    <TouchableOpacity onPress={openDrawer} style={[styles.iconButton, { backgroundColor: isDark ? '#374151' : '#F5F5F5' }]}>
                        <Ionicons name="grid-outline" size={22} color={iconColor} />
                    </TouchableOpacity>
                )}
            </View>

            {/* Center Side - Logo or Title */}
            <View style={styles.headerCenter}>
                {title ? (
                    <Text style={[styles.title, { color: isDark ? '#F9FAFB' : '#171717' }]}>{title}</Text>
                ) : showLogo && (
                    <Image
                        source={require('../assets/images/recom-logo.png')}
                        style={styles.logo}
                        resizeMode="contain"
                    />
                )}
            </View>

            {/* Right Side */}
            <View style={styles.headerRight}>
                {showNotification && (
                    <TouchableOpacity
                        onPress={() => router.push('/(tabs)/notifications' as any)}
                        style={styles.notifButton}
                    >
                        <Ionicons name="notifications-outline" size={24} color={iconColor} />
                        <View style={styles.badge}>
                            <Text style={styles.badgeText}>3</Text>
                        </View>
                    </TouchableOpacity>
                )}
                {showLogout && (
                    <TouchableOpacity onPress={handleLogout} style={styles.logoutButton}>
                        <Ionicons name="log-out-outline" size={24} color="#EF4444" />
                    </TouchableOpacity>
                )}
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingHorizontal: 16,
        paddingVertical: 12,
        borderBottomWidth: 1,
    },
    headerLeft: {
        flex: 1, // Take up space to help center the middle
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-start',
    },
    headerCenter: {
        flex: 2, // Take up more space for logo/title
        alignItems: 'center',
        justifyContent: 'center',
    },
    headerRight: {
        flex: 1, // Balances left side
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end',
        gap: 8,
    },
    iconButton: {
        padding: 8,
        borderRadius: 8,
    },
    logo: {
        width: 120, // Slightly larger for center
        height: 36,
    },
    title: {
        fontSize: 18,
        fontWeight: 'bold',
    },
    notifButton: {
        position: 'relative',
        padding: 8,
    },
    logoutButton: {
        padding: 8,
    },
    badge: {
        position: 'absolute',
        top: 4,
        right: 4,
        backgroundColor: '#EF4444',
        borderRadius: 10,
        minWidth: 18,
        height: 18,
        alignItems: 'center',
        justifyContent: 'center',
    },
    badgeText: {
        color: 'white',
        fontSize: 10,
        fontWeight: 'bold',
    },
});
