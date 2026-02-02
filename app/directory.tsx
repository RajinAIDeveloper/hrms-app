import React, { useState } from 'react';
import { View, Text, TextInput, FlatList, Image, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useTheme } from '../context/ThemeContext';
import AppHeader from '../components/AppHeader';

// Mock Data for Employees
const EMPLOYEES = [
    {
        id: '101',
        name: 'Rahim Ahmed',
        role: 'Senior UI/UX Designer',
        department: 'Design',
        designation: 'Senior UI/UX Designer',
        location: 'Dhaka',
        phone: '+880 1712 345678',
        email: 'rahim.ahmed@hrms.com',
        avatar: 'https://cdn.usegalileo.ai/sdxl10/68175782-9905-4dcf-8848-f2b7a97fd22f.png',
        status: 'Present',
    },
    {
        id: '102',
        name: 'Sarah Khan',
        role: 'Product Manager',
        department: 'Product',
        designation: 'Product Manager',
        location: 'Dhaka',
        phone: '+880 1711 223344',
        email: 'sarah.khan@hrms.com',
        avatar: 'https://cdn.usegalileo.ai/stability/16602e64-1627-466d-a60d-773df40a6311.png',
        status: 'On Leave',
    },
    {
        id: '103',
        name: 'Karim Ullah',
        role: 'Flutter Developer',
        department: 'Engineering',
        designation: 'Lead Developer',
        location: 'Chittagong',
        phone: '+880 1819 876543',
        email: 'karim.ullah@hrms.com',
        avatar: 'https://cdn.usegalileo.ai/stability/e4501479-7dd2-4b2a-b605-7287d2516628.png',
        status: 'Remote',
    },
    {
        id: '104',
        name: 'Nusrat Jahan',
        role: 'HR Executive',
        department: 'Human Resources',
        designation: 'HR Specialist',
        location: 'Dhaka',
        phone: '+880 1912 345678',
        email: 'nusrat.jahan@hrms.com',
        avatar: 'https://cdn.usegalileo.ai/stability/f382103f-42e5-4204-b631-c062c332822a.png',
        status: 'Present',
    },
    {
        id: '105',
        name: 'Rafiq Islam',
        role: 'Backend Developer',
        department: 'Engineering',
        designation: 'Senior Developer',
        location: 'Sylhet',
        phone: '+880 1555 123456',
        email: 'rafiq.islam@hrms.com',
        avatar: 'https://cdn.usegalileo.ai/stability/1fb26364-7067-4257-bcd6-24ba0473ce18.png',
        status: 'Present',
    },
];

const DEPARTMENTS = ['All', 'Design', 'Engineering', 'Product', 'Human Resources', 'Sales'];
const LOCATIONS = ['All', 'Dhaka', 'Chittagong', 'Sylhet', 'Remote'];
const DESIGNATIONS = ['All', 'Senior UI/UX Designer', 'Product Manager', 'Lead Developer', 'Senior Developer', 'HR Specialist'];

export default function EmployeeDirectory() {
    const router = useRouter();
    const { isDark } = useTheme();
    const [searchQuery, setSearchQuery] = useState('');
    const [selectedDept, setSelectedDept] = useState('All');
    const [selectedLoc, setSelectedLoc] = useState('All');
    const [selectedDesig, setSelectedDesig] = useState('All');
    const [showFilters, setShowFilters] = useState(false);

    const styles = getStyles(isDark);

    const filteredEmployees = EMPLOYEES.filter((employee) => {
        const matchesSearch = employee.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
            employee.id.includes(searchQuery) ||
            employee.role.toLowerCase().includes(searchQuery.toLowerCase());
        const matchesDept = selectedDept === 'All' || employee.department === selectedDept;
        const matchesLoc = selectedLoc === 'All' || employee.location === selectedLoc;
        const matchesDesig = selectedDesig === 'All' || employee.designation === selectedDesig;
        return matchesSearch && matchesDept && matchesLoc && matchesDesig;
    });

    const renderEmployeeCard = ({ item }: { item: typeof EMPLOYEES[0] }) => (
        <View style={styles.card}>
            <View style={styles.avatarContainer}>
                <Image
                    source={{ uri: item.avatar }}
                    style={styles.avatar}
                />
                <View style={[styles.statusDot,
                item.status === 'Present' ? styles.bgGreen :
                    item.status === 'On Leave' ? styles.bgRed : styles.bgBlue]}
                />
            </View>

            <View style={{ flex: 1 }}>
                <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                    <Text style={styles.name}>{item.name}</Text>
                    {item.status !== 'Present' && (
                        <View style={[styles.statusBadge,
                        item.status === 'On Leave' ? styles.badgeRed : styles.badgeBlue]}>
                            <Text style={[styles.statusText,
                            item.status === 'On Leave' ? styles.textRed : styles.textBlue]}>{item.status}</Text>
                        </View>
                    )}
                </View>
                <Text style={styles.role}>{item.role}</Text>

                <View style={styles.actionRow}>
                    <TouchableOpacity onPress={() => console.log('Call', item.phone)}>
                        <Ionicons name="call-outline" size={16} color="#A3A3A3" />
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => console.log('Email', item.email)}>
                        <Ionicons name="mail-outline" size={16} color="#A3A3A3" />
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    );

    return (
        <SafeAreaView style={styles.container} edges={['top']}>
            {/* Header */}
            <AppHeader showMenu={false} showBack={true} showLogo={true} showLogout={false} showNotification={false} />


            <View style={styles.header}>
                <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
                    <Text style={[styles.headerTitle, { marginHorizontal: 0, marginBottom: 0 }]}>Directory</Text>
                    <TouchableOpacity
                        onPress={() => setShowFilters(!showFilters)}
                        style={[styles.filterBtn, showFilters && { backgroundColor: '#2563EB' }]}
                    >
                        <Ionicons name="options-outline" size={20} color={showFilters ? 'white' : '#A3A3A3'} />
                    </TouchableOpacity>
                </View>

                {/* Search Bar */}
                <View style={styles.searchContainer}>
                    <Ionicons name="search-outline" size={20} color="#A3A3A3" style={{ marginRight: 8 }} />
                    <TextInput
                        placeholder="Search by name, ID or role..."
                        value={searchQuery}
                        onChangeText={setSearchQuery}
                        style={styles.searchInput}
                        placeholderTextColor="#A3A3A3"
                    />
                </View>

                {/* Advanced Filters */}
                {showFilters && (
                    <View style={styles.advancedFilters}>
                        <Text style={styles.filterLabel}>Department</Text>
                        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterScroll}>
                            {DEPARTMENTS.map((dept) => (
                                <TouchableOpacity
                                    key={dept}
                                    onPress={() => setSelectedDept(dept)}
                                    style={[styles.filterPill, selectedDept === dept ? styles.pillActive : styles.pillInactive]}
                                >
                                    <Text style={[styles.pillText, selectedDept === dept ? styles.pillTextActive : styles.pillTextInactive]}>{dept}</Text>
                                </TouchableOpacity>
                            ))}
                        </ScrollView>

                        <Text style={styles.filterLabel}>Designation</Text>
                        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterScroll}>
                            {DESIGNATIONS.map((desig) => (
                                <TouchableOpacity
                                    key={desig}
                                    onPress={() => setSelectedDesig(desig)}
                                    style={[styles.filterPill, selectedDesig === desig ? styles.pillActive : styles.pillInactive]}
                                >
                                    <Text style={[styles.pillText, selectedDesig === desig ? styles.pillTextActive : styles.pillTextInactive]}>{desig}</Text>
                                </TouchableOpacity>
                            ))}
                        </ScrollView>

                        <Text style={styles.filterLabel}>Location</Text>
                        <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterScroll}>
                            {LOCATIONS.map((loc) => (
                                <TouchableOpacity
                                    key={loc}
                                    onPress={() => setSelectedLoc(loc)}
                                    style={[styles.filterPill, selectedLoc === loc ? styles.pillActive : styles.pillInactive]}
                                >
                                    <Text style={[styles.pillText, selectedLoc === loc ? styles.pillTextActive : styles.pillTextInactive]}>{loc}</Text>
                                </TouchableOpacity>
                            ))}
                        </ScrollView>
                    </View>
                )}
            </View>

            {/* Employee List */}
            <FlatList
                data={filteredEmployees}
                renderItem={renderEmployeeCard}
                keyExtractor={(item) => item.id}
                contentContainerStyle={{ padding: 20 }}
                ListEmptyComponent={
                    <View style={styles.emptyContainer}>
                        <Text style={styles.emptyText}>No employees found</Text>
                    </View>
                }
            />
        </SafeAreaView>
    );
}

const getStyles = (isDark: boolean) => StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: isDark ? '#111827' : '#FAFAFA',
    },
    header: {
        paddingHorizontal: 20,
        paddingVertical: 16,
        backgroundColor: isDark ? '#1F2937' : 'white',
        borderBottomWidth: 1,
        borderBottomColor: isDark ? '#374151' : '#F5F5F5',
    },
    headerTitle: {
        fontSize: 24,
        fontWeight: 'bold',
        color: isDark ? '#F9FAFB' : '#171717',
    },
    filterBtn: {
        padding: 8,
        borderRadius: 8,
        backgroundColor: isDark ? '#374151' : '#F5F5F5',
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: isDark ? '#374151' : '#F5F5F5',
        paddingHorizontal: 16,
        paddingVertical: 12,
        borderRadius: 12,
    },
    searchInput: {
        flex: 1,
        fontSize: 16,
        color: isDark ? '#F9FAFB' : '#171717',
    },
    advancedFilters: {
        marginTop: 16,
        gap: 8,
    },
    filterLabel: {
        fontSize: 12,
        fontWeight: 'bold',
        color: isDark ? '#9CA3AF' : '#737373',
        marginTop: 8,
        textTransform: 'uppercase',
    },
    filterScroll: {
        marginTop: 4,
    },
    filterPill: {
        marginRight: 8,
        paddingHorizontal: 16,
        paddingVertical: 8,
        borderRadius: 9999,
        borderWidth: 1,
    },
    pillActive: {
        backgroundColor: '#2563EB',
        borderColor: '#2563EB',
    },
    pillInactive: {
        backgroundColor: isDark ? '#1F2937' : 'white',
        borderColor: isDark ? '#4B5563' : '#E5E5E5',
    },
    pillText: {
        fontWeight: '500',
    },
    pillTextActive: {
        color: 'white',
    },
    pillTextInactive: {
        color: isDark ? '#9CA3AF' : '#525252',
    },
    card: {
        backgroundColor: isDark ? '#1F2937' : 'white',
        padding: 16,
        borderRadius: 12,
        marginBottom: 12,
        flexDirection: 'row',
        alignItems: 'center',
        gap: 16,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 2,
        elevation: 2,
        borderWidth: 1,
        borderColor: isDark ? '#374151' : '#F5F5F5',
    },
    avatarContainer: {
        position: 'relative',
    },
    avatar: {
        width: 56,
        height: 56,
        borderRadius: 28,
        backgroundColor: isDark ? '#374151' : '#F5F5F5',
    },
    statusDot: {
        position: 'absolute',
        bottom: 0,
        right: 0,
        width: 14,
        height: 14,
        borderRadius: 7,
        borderWidth: 2,
        borderColor: isDark ? '#1F2937' : 'white',
    },
    bgGreen: { backgroundColor: '#22C55E' },
    bgRed: { backgroundColor: '#EF4444' },
    bgBlue: { backgroundColor: '#3B82F6' },
    name: {
        fontWeight: 'bold',
        color: isDark ? '#F9FAFB' : '#171717',
        fontSize: 16,
    },
    role: {
        color: isDark ? '#9CA3AF' : '#737373',
        fontSize: 14,
    },
    statusBadge: {
        paddingHorizontal: 8,
        paddingVertical: 2,
        borderRadius: 4,
    },
    badgeRed: { backgroundColor: isDark ? 'rgba(239, 68, 68, 0.2)' : '#FEF2F2' },
    badgeBlue: { backgroundColor: isDark ? 'rgba(59, 130, 246, 0.2)' : '#EFF6FF' },
    statusText: { fontSize: 10, fontWeight: '500' },
    textRed: { color: isDark ? '#FCA5A5' : '#DC2626' },
    textBlue: { color: isDark ? '#93C5FD' : '#2563EB' },
    actionRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 8,
        gap: 12,
    },
    emptyContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: 80,
    },
    emptyText: {
        color: isDark ? '#6B7280' : '#A3A3A3',
        fontSize: 16,
    },
});
