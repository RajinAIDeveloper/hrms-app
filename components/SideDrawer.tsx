import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import React, { useEffect } from 'react';
import { Dimensions, Pressable, StyleSheet, Text, View, Alert } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withTiming } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Colors } from '../constants/Colors';
import { useDrawer } from '../context/DrawerContext';
import { useTheme } from '../context/ThemeContext';

const { width } = Dimensions.get('window');
const DRAWER_WIDTH = Math.min(320, Math.round(width * 0.82));

const ITEMS = [
    { label: 'Events', icon: 'calendar-outline', route: '/events' },
    { label: 'Gallery', icon: 'images-outline', route: '/gallery' },
    { label: 'Islamic Library', icon: 'book-outline', route: '/islamic-library' },
] as const;

// Drawer Component
export default function SideDrawer() {
    const router = useRouter();
    const { isOpen, closeDrawer } = useDrawer();
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];
    const insets = useSafeAreaInsets();

    const progress = useSharedValue(0);

    useEffect(() => {
        progress.value = withTiming(isOpen ? 1 : 0, { duration: 220 });
    }, [isOpen, progress]);

    const overlayAnimatedStyle = useAnimatedStyle(() => ({
        opacity: progress.value * 0.45,
    }));

    const drawerAnimatedStyle = useAnimatedStyle(() => ({
        transform: [{ translateX: -DRAWER_WIDTH + progress.value * DRAWER_WIDTH }],
    }));

    const onNavigate = (item: typeof ITEMS[number]) => {
        closeDrawer();

        // All drawer items are currently Coming Soon
        setTimeout(() => {
            Alert.alert(
                "🚀 Coming Soon!",
                `The ${item.label} module is currently under development. Stay tuned for updates!`,
                [{ text: "Can't Wait!" }]
            );
        }, 300);
    };

    return (
        <View pointerEvents={isOpen ? 'auto' : 'none'} style={styles.root}>
            <Pressable onPress={closeDrawer} style={StyleSheet.absoluteFill}>
                <Animated.View style={[styles.overlay, overlayAnimatedStyle]} />
            </Pressable>

            <Animated.View
                style={[
                    styles.drawer,
                    drawerAnimatedStyle,
                    { backgroundColor: theme.card, borderRightColor: theme.border, paddingTop: insets.top },
                ]}
            >
                {/* Header Profile Snippet */}
                <View style={[styles.drawerHeader, { borderBottomColor: theme.border }]}>
                    <View style={styles.headerProfile}>
                        <View style={[styles.profileAvatar, { backgroundColor: theme.primary }]}>
                            <Text style={styles.profileInitials}>RA</Text>
                        </View>
                        <View>
                            <Text style={[styles.profileName, { color: theme.text }]}>Rahim Ahmed</Text>
                            <Text style={[styles.profileSubtitle, { color: theme.subtext }]}>Senior Designer</Text>
                        </View>
                    </View>
                    <Pressable onPress={closeDrawer} hitSlop={10} style={[styles.closeBtn, { backgroundColor: theme.background }]}>
                        <Ionicons name="close" size={20} color={theme.text} />
                    </Pressable>
                </View>

                {/* Items */}
                <View style={styles.items}>
                    <Text style={[styles.sectionTitle, { color: theme.subtext }]}>Menu</Text>
                    {ITEMS.map((item) => (
                        <Pressable
                            key={item.route}
                            onPress={() => onNavigate(item)}
                            style={({ pressed }) => [
                                styles.item,
                                {
                                    backgroundColor: pressed ? theme.primary + '10' : 'transparent',
                                },
                            ]}
                        >
                            <View style={[styles.itemIcon, { backgroundColor: item.label === 'Islamic Library' ? '#10B98120' : theme.primary + '15' }]}>
                                <Ionicons
                                    name={item.icon as any}
                                    size={20}
                                    color={item.label === 'Islamic Library' ? '#10B981' : theme.primary}
                                />
                            </View>
                            <Text style={[styles.itemLabel, { color: theme.text }]}>{item.label}</Text>
                            {item.label === 'Islamic Library' && (
                                <View style={[styles.newBadge, { backgroundColor: '#10B981' }]}>
                                    <Text style={styles.newBadgeText}>NEW</Text>
                                </View>
                            )}
                            <Ionicons name="chevron-forward" size={16} color={theme.subtext} />
                        </Pressable>
                    ))}
                </View>

                {/* Footer */}
                <View style={[styles.drawerFooter, { borderTopColor: theme.border }]}>
                    <Text style={[styles.footerText, { color: theme.subtext }]}>App Version 1.0.5</Text>
                    <Text style={[styles.footerText, { color: theme.subtext, fontSize: 10 }]}>© 2026 HRMS Inc.</Text>
                </View>
            </Animated.View>
        </View>
    );
}

const styles = StyleSheet.create({
    root: {
        ...StyleSheet.absoluteFillObject,
        zIndex: 9999,
    },
    overlay: {
        ...StyleSheet.absoluteFillObject,
        backgroundColor: '#000',
    },
    drawer: {
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        width: DRAWER_WIDTH,
        borderRightWidth: 1,
        paddingTop: 0,
        justifyContent: 'space-between',
    },
    drawerHeader: {
        paddingHorizontal: 20,
        paddingVertical: 20,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomWidth: 1,
    },
    headerProfile: { flexDirection: 'row', alignItems: 'center', gap: 12 },
    profileAvatar: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center' },
    profileInitials: { color: 'white', fontWeight: '700', fontSize: 16 },
    profileName: { fontSize: 16, fontWeight: '700' },
    profileSubtitle: { fontSize: 12 },
    closeBtn: { padding: 8, borderRadius: 20 },

    sectionTitle: { fontSize: 12, fontWeight: '700', textTransform: 'uppercase', marginBottom: 12, paddingHorizontal: 12, opacity: 0.7 },

    items: {
        flex: 1,
        paddingTop: 24,
        paddingHorizontal: 16,
        gap: 8,
    },
    item: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 12,
        paddingHorizontal: 12,
        borderRadius: 14,
        gap: 12,
    },
    itemIcon: {
        width: 38,
        height: 38,
        borderRadius: 12,
        alignItems: 'center',
        justifyContent: 'center',
    },
    itemLabel: {
        flex: 1,
        fontSize: 15,
        fontWeight: '600',
    },
    newBadge: { paddingHorizontal: 6, paddingVertical: 2, borderRadius: 4, marginRight: 4 },
    newBadgeText: { fontSize: 10, fontWeight: '800', color: 'white' },

    drawerFooter: {
        paddingHorizontal: 24,
        paddingBottom: 40,
        paddingTop: 20,
        borderTopWidth: 1,
        alignItems: 'center',
    },
    footerText: {
        fontSize: 12,
        fontWeight: '500',
        textAlign: 'center',
        marginBottom: 4,
    },
});
