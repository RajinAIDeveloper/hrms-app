import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../../context/ThemeContext';

export default function BankDetailsScreen() {
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
                <Text style={styles.headerTitle}>Bank Details</Text>
                <View style={{ width: 24 }} />
            </View>

            <View style={styles.content}>
                <View style={styles.card}>
                    <Text style={styles.bankName}>Dutch-Bangla Bank Ltd</Text>
                    <Text style={styles.accountNumber}>**** **** **** 4582</Text>
                    <View style={styles.row}>
                        <View>
                            <Text style={styles.label}>Account Holder</Text>
                            <Text style={styles.value}>Rahim Ahmed</Text>
                        </View>
                        <View>
                            <Text style={styles.label}>Branch</Text>
                            <Text style={styles.value}>Gulshan Circle 1</Text>
                        </View>
                    </View>
                </View>
            </View>
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: { flex: 1, backgroundColor: isDark ? '#111827' : '#FAFAFA' },
    header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', padding: 20, backgroundColor: isDark ? '#1F2937' : 'white', borderBottomWidth: 1, borderBottomColor: isDark ? '#374151' : '#F5F5F5' },
    headerTitle: { fontSize: 18, fontWeight: 'bold', color: isDark ? '#F9FAFB' : '#171717' },
    content: { padding: 20 },
    card: { backgroundColor: '#1E293B', padding: 24, borderRadius: 16, shadowColor: '#000', shadowOpacity: 0.1, shadowRadius: 10, elevation: 5 },
    bankName: { fontSize: 18, fontWeight: 'bold', color: 'white', marginBottom: 24 },
    accountNumber: { fontSize: 24, letterSpacing: 2, color: 'white', marginBottom: 24, fontFamily: 'monospace' },
    row: { flexDirection: 'row', justifyContent: 'space-between' },
    label: { fontSize: 12, color: '#94A3B8', marginBottom: 4 },
    value: { fontSize: 16, fontWeight: '600', color: 'white' },
});
