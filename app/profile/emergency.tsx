import React from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../../context/ThemeContext';

export default function EmergencyContactsScreen() {
    const router = useRouter();
    const { isDark } = useTheme();

    // Dynamic Styles
    const styles = getStyles(isDark);
    const iconColor = isDark ? '#F9FAFB' : '#171717';

    return (
        <SafeAreaView style={styles.container} edges={['top']}>
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()}>
                    <Ionicons name="arrow-back" size={24} color={iconColor} />
                </TouchableOpacity>
                <Text style={styles.headerTitle}>Emergency Contacts</Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                <View style={styles.card}>
                    <Text style={styles.relation}>Spouse</Text>
                    <Text style={styles.name}>Fatima Ahmed</Text>
                    <TouchableOpacity style={styles.phoneRow}>
                        <Ionicons name="call" size={20} color={isDark ? '#60A5FA' : '#2563EB'} />
                        <Text style={styles.phone}>+880 1999 888777</Text>
                    </TouchableOpacity>
                </View>

                <View style={styles.card}>
                    <Text style={styles.relation}>Father</Text>
                    <Text style={styles.name}>Abdul Malik</Text>
                    <TouchableOpacity style={styles.phoneRow}>
                        <Ionicons name="call" size={20} color={isDark ? '#60A5FA' : '#2563EB'} />
                        <Text style={styles.phone}>+880 1555 444333</Text>
                    </TouchableOpacity>
                </View>
            </ScrollView>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#FAFAFA' },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 20, backgroundColor: isDark ? '#1F2937' : 'white', borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F5F5F5' },
    headerTitle: { fontSize: 18, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    content: { padding: 20 },
    card: { backgroundColor: isDark ? '#1F2937' : 'white', padding: 20, borderRadius: 12, marginBottom: 12, borderLeftWidth: 4, borderLeftColor: '#EF4444' },
    relation: { fontSize: 12, color: isDark ? '#9CA3AF' : '#737373', textTransform: 'uppercase', marginBottom: 4 },
    name: { fontSize: 18, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717', marginBottom: 12 },
    phoneRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
    phone: { fontSize: 16, color: isDark ? '#60A5FA' : '#2563EB', fontWeight: '500' },
});
