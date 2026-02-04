import React from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '@/constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';
import { router } from 'expo-router';
import { useTheme } from '@/context/ThemeContext';

const NOTIFICATIONS = [
    { id: '1', title: 'Leave Approved', message: 'Your leave request for Feb 10-12 has been approved by HR.', time: '2 hours ago', icon: 'checkmark-circle', color: '#10B981', read: false },
    { id: '2', title: 'Payslip Available', message: 'Your payslip for January 2026 is now available for download.', time: '1 day ago', icon: 'document-text', color: '#3B82F6', read: true },
    { id: '3', title: 'Policy Update', message: 'The remote work policy has been updated. Please review the changes.', time: '3 days ago', icon: 'information-circle', color: '#F59E0B', read: true },
    { id: '4', title: 'Welcome to Recom', message: 'Welcome aboard! Check out your dashboard to get started.', time: '1 week ago', icon: 'rocket', color: '#8B5CF6', read: true },
];

const NotificationItem = ({ item, theme, index }: any) => (
    <Animated.View entering={FadeInDown.delay(index * 100).duration(400)}>
        <TouchableOpacity style={[styles.itemCard, { backgroundColor: item.read ? theme.background : theme.card, borderColor: theme.border }]}>
            <View style={[styles.iconContainer, { backgroundColor: item.color + '15' }]}>
                <Ionicons name={item.icon} size={24} color={item.color} />
            </View>
            <View style={styles.textContainer}>
                <View style={styles.headerRow}>
                    <Text style={[styles.itemTitle, { color: theme.text, fontWeight: item.read ? '600' : '700' }]}>{item.title}</Text>
                    <Text style={[styles.itemTime, { color: theme.subtext }]}>{item.time}</Text>
                </View>
                <Text style={[styles.itemMessage, { color: theme.subtext }]} numberOfLines={2}>{item.message}</Text>
            </View>
            {!item.read && <View style={[styles.unreadDot, { backgroundColor: theme.primary }]} />}
        </TouchableOpacity>
    </Animated.View>
);

export default function NotificationsScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <View style={[styles.header, { backgroundColor: theme.card, borderBottomColor: theme.border }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <Ionicons name="arrow-back" size={24} color={theme.text} />
                </TouchableOpacity>
                <Text style={[styles.headerTitle, { color: theme.text }]}>Notifications</Text>
                <View style={{ width: 40 }} />
            </View>

            <FlatList
                data={NOTIFICATIONS}
                keyExtractor={item => item.id}
                renderItem={({ item, index }) => <NotificationItem item={item} theme={theme} index={index} />}
                contentContainerStyle={styles.listContent}
                showsVerticalScrollIndicator={false}
            />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 16, borderBottomWidth: 1 },
    backButton: { padding: 8 },
    headerTitle: { fontSize: 20, fontWeight: '700' },
    listContent: { padding: 16 },
    itemCard: { flexDirection: 'row', padding: 16, marginBottom: 12, borderRadius: 16, borderWidth: 1, alignItems: 'center', gap: 16 },
    iconContainer: { width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' },
    textContainer: { flex: 1 },
    headerRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
    itemTitle: { fontSize: 15 },
    itemTime: { fontSize: 12 },
    itemMessage: { fontSize: 13, lineHeight: 18 },
    unreadDot: { width: 8, height: 8, borderRadius: 4, position: 'absolute', top: 16, right: 16 },
});
