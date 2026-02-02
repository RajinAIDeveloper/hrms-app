import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Dimensions } from 'react-native';
import { BottomTabBarProps } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import Animated, {
    useSharedValue,
    useAnimatedStyle,
    withSpring,
    interpolate
} from 'react-native-reanimated';
import { useTheme } from '../context/ThemeContext';

const MAIN_TABS = ['index', 'attendance', 'payroll', 'profile'];
const { width } = Dimensions.get('window');

// --- FAB Menu Component (integrated) ---
const FABMenu = ({ isDark, onNavigate }: { isDark: boolean; onNavigate: (r: string) => void }) => {
    const [isOpen, setIsOpen] = useState(false);
    const progress = useSharedValue(0);

    const toggleMenu = () => {
        const nextState = !isOpen;
        setIsOpen(nextState);
        progress.value = withSpring(nextState ? 1 : 0, { damping: 12, stiffness: 90 });
    };

    const fabStyle = useAnimatedStyle(() => ({
        transform: [{ rotate: `${progress.value * 45}deg` }],
    }));

    const MenuItem = ({ icon, color, label, route, index, total }: any) => {
        const angle = -180 + (180 / (total + 1)) * (index + 1);
        const radius = 90;

        const rStyle = useAnimatedStyle(() => {
            const rad = angle * (Math.PI / 180);
            const tx = Math.cos(rad) * radius * progress.value;
            const ty = Math.sin(rad) * radius * progress.value;
            const scale = interpolate(progress.value, [0, 1], [0, 1]);
            const opacity = interpolate(progress.value, [0, 0.5, 1], [0, 0, 1]);

            return {
                transform: [{ translateX: tx }, { translateY: ty }, { scale }],
                opacity,
            };
        });

        return (
            <Animated.View style={[styles.menuItemContainer, rStyle]}>
                <TouchableOpacity
                    style={[styles.menuItem, { backgroundColor: color }]}
                    onPress={() => {
                        toggleMenu();
                        setTimeout(() => onNavigate(route), 200);
                    }}
                >
                    <Ionicons name={icon} size={22} color="white" />
                </TouchableOpacity>
                <Animated.Text style={[styles.menuLabel, { color: isDark ? 'white' : '#374151', opacity: progress }]}>
                    {label}
                </Animated.Text>
            </Animated.View>
        );
    };

    return (
        <View style={styles.fabWrapper}>
            {/* Menu Items */}
            {/* Menu Items */}
            <MenuItem index={0} total={3} icon="time" color="#F59E0B" label="WorkShift" route="/shift-details" />
            <MenuItem index={1} total={3} icon="people" color="#10B981" label="Directory" route="/directory" />
            <MenuItem index={2} total={3} icon="shield-checkmark" color="#8B5CF6" label="Policies" route="/policies" />

            {/* Main FAB */}
            <TouchableOpacity onPress={toggleMenu} activeOpacity={0.8} style={styles.fabButtonContainer}>
                <Animated.View style={[styles.fabButton, fabStyle]}>
                    <Ionicons name="add" size={32} color="white" />
                </Animated.View>
            </TouchableOpacity>
        </View>
    );
};

export default function CustomTabBar({ state, descriptors, navigation }: BottomTabBarProps) {
    const { isDark } = useTheme();
    const router = useRouter();

    const bgColor = isDark ? '#1F2937' : 'white';
    const borderColor = isDark ? '#374151' : '#F5F5F5';

    const visibleRoutes = state.routes.filter(route => MAIN_TABS.includes(route.name));

    const getIconName = (name: string, focused: boolean): keyof typeof Ionicons.glyphMap => {
        switch (name) {
            case 'index': return focused ? 'home' : 'home-outline';
            case 'attendance': return focused ? 'calendar' : 'calendar-outline';
            case 'payroll': return focused ? 'card' : 'card-outline';
            case 'profile': return focused ? 'person' : 'person-outline';
            default: return 'ellipse-outline';
        }
    };

    return (
        <View style={[styles.container, { backgroundColor: bgColor, borderTopColor: borderColor }]}>
            {visibleRoutes.map((route, index) => {
                const { options } = descriptors[route.key];
                const originalIndex = state.routes.indexOf(route);
                const isFocused = state.index === originalIndex;
                const color = isFocused ? '#2563EB' : (isDark ? '#9CA3AF' : '#A3A3A3');
                const iconName = getIconName(route.name, isFocused);

                const onPress = () => {
                    const event = navigation.emit({
                        type: 'tabPress',
                        target: route.key,
                        canPreventDefault: true,
                    });

                    if (!isFocused && !event.defaultPrevented) {
                        navigation.navigate(route.name);
                    }
                };

                // Insert FAB after 2nd item (index 1)
                const isSecondItem = index === 1;

                return (
                    <React.Fragment key={route.key}>
                        <TouchableOpacity onPress={onPress} style={styles.tabItem}>
                            <Ionicons name={iconName} size={24} color={color} />
                            <Text style={[styles.tabLabel, { color }]}>{options.title}</Text>
                        </TouchableOpacity>

                        {isSecondItem && (
                            <View style={styles.fabSpace}>
                                <FABMenu isDark={isDark} onNavigate={(r) => router.push(r as any)} />
                            </View>
                        )}
                    </React.Fragment>
                );
            })}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        paddingTop: 8,
        paddingBottom: 24,
        borderTopWidth: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -5 },
        shadowOpacity: 0.05,
        shadowRadius: 10,
        elevation: 5,
        height: 80,
    },
    tabItem: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
    tabLabel: {
        fontSize: 10,
        marginTop: 4,
    },
    fabSpace: {
        width: 60,
        alignItems: 'center',
        justifyContent: 'flex-end',
        zIndex: 10,
    },
    fabWrapper: {
        position: 'absolute',
        bottom: 25, // Push it up to overlap the bar slightly
        alignItems: 'center',
    },
    fabButtonContainer: {
        // Container to ensure consistent hit slop
    },
    fabButton: {
        backgroundColor: '#2563EB',
        width: 56,
        height: 56,
        borderRadius: 28,
        alignItems: 'center',
        justifyContent: 'center',
        shadowColor: '#3B82F6',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.4,
        shadowRadius: 8,
        elevation: 8,
    },
    menuItemContainer: {
        position: 'absolute',
        alignItems: 'center',
        width: 60,
        height: 60,
        bottom: 0,
    },
    menuItem: {
        width: 44,
        height: 44,
        borderRadius: 22,
        alignItems: 'center',
        justifyContent: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        shadowRadius: 4,
        elevation: 6,
        marginBottom: 4,
    },
    menuLabel: {
        fontSize: 10,
        fontWeight: 'bold',
        textAlign: 'center',
        width: 80,
    },
});
