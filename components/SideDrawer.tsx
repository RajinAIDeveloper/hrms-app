import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import React, { useEffect } from 'react';
import { Dimensions, Pressable, StyleSheet, Text, View } from 'react-native';
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

    const onNavigate = (route: (typeof ITEMS)[number]['route']) => {
        closeDrawer();
        setTimeout(() => router.push(route as any), 180);
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
                    { backgroundColor: theme.card, borderRightColor: theme.border, paddingTop: insets.top + 12 },
                ]}
            >
                <View style={[styles.drawerHeader, { borderBottomColor: theme.border }]}>
                    <Text style={[styles.drawerTitle, { color: theme.text }]}>Menu</Text>
                    <Pressable onPress={closeDrawer} hitSlop={10}>
                        <Ionicons name="close" size={22} color={theme.subtext} />
                    </Pressable>
                </View>

                <View style={styles.items}>
                    {ITEMS.map((item) => (
                        <Pressable
                            key={item.route}
                            onPress={() => onNavigate(item.route)}
                            style={({ pressed }) => [
                                styles.item,
                                {
                                    backgroundColor: pressed ? theme.primary + '10' : 'transparent',
                                },
                            ]}
                        >
                            <View style={[styles.itemIcon, { backgroundColor: theme.primary + '15' }]}>
                                <Ionicons name={item.icon as any} size={20} color={theme.primary} />
                            </View>
                            <Text style={[styles.itemLabel, { color: theme.text }]}>{item.label}</Text>
                            <Ionicons name="chevron-forward" size={18} color={theme.subtext} />
                        </Pressable>
                    ))}
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
    },
    drawerHeader: {
        paddingHorizontal: 16,
        paddingBottom: 12,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomWidth: 1,
    },
    drawerTitle: {
        fontSize: 18,
        fontWeight: '700',
    },
    items: {
        paddingTop: 12,
        paddingHorizontal: 12,
        gap: 4,
    },
    item: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 12,
        paddingHorizontal: 12,
        borderRadius: 12,
        gap: 12,
    },
    itemIcon: {
        width: 36,
        height: 36,
        borderRadius: 10,
        alignItems: 'center',
        justifyContent: 'center',
    },
    itemLabel: {
        flex: 1,
        fontSize: 15,
        fontWeight: '600',
    },
    drawerFooter: {
        marginTop: 'auto',
        paddingHorizontal: 16,
        paddingVertical: 14,
        borderTopWidth: 1,
    },
    footerText: {
        fontSize: 12,
        fontWeight: '600',
    },
});
