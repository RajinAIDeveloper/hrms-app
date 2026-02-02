import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, TextInput, Alert, Image } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '../constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown } from 'react-native-reanimated';
import { useColorScheme } from '../hooks/use-color-scheme';
import AppHeader from '../components/AppHeader';

const POLICY_DOCS = [
    { id: 1, title: 'Employee Handbook 2026', category: 'HR', size: '2.4 MB', date: 'Jan 10, 2026', icon: 'book' },
    { id: 2, title: 'IT Security Policy', category: 'IT', size: '1.2 MB', date: 'Dec 15, 2025', icon: 'shield-checkmark' },
    { id: 3, title: 'Leave & Attendance Policy', category: 'HR', size: '850 KB', date: 'Jan 05, 2026', icon: 'calendar' },
    { id: 4, title: 'Travel & Expense Guidelines', category: 'Finance', size: '1.8 MB', date: 'Nov 20, 2025', icon: 'airplane' },
    { id: 5, title: 'Code of Conduct', category: 'Legal', size: '3.0 MB', date: 'Jan 01, 2026', icon: 'document-text' },
    { id: 6, title: 'Health & Safety Protocols', category: 'Ops', size: '1.5 MB', date: 'Oct 12, 2025', icon: 'medkit' },
];

const CATEGORIES = ['All', 'HR', 'IT', 'Finance', 'Legal', 'Ops'];

export default function PoliciesScreen() {
    const colorScheme = useColorScheme();
    const theme = Colors[colorScheme ?? 'light'];

    const [search, setSearch] = useState('');
    const [selectedCategory, setSelectedCategory] = useState('All');

    const filteredDocs = POLICY_DOCS.filter(doc => {
        const matchesSearch = doc.title.toLowerCase().includes(search.toLowerCase());
        const matchesCategory = selectedCategory === 'All' || doc.category === selectedCategory;
        return matchesSearch && matchesCategory;
    });

    const handleDownload = (title: string) => {
        Alert.alert("⬇️ Downloading...", `Starting download for ${title}`);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} />

            <AppHeader showBack={true} showLogo={true} />

            {/* Fixed Header Section */}
            <View>
                <View style={styles.titleRow}>
                    <Text style={[styles.title, { color: theme.text }]}>📜 Policies</Text>
                    <View style={[styles.countBadge, { backgroundColor: theme.card, borderColor: theme.border }]}>
                        <Text style={[styles.count, { color: theme.subtext }]}>{filteredDocs.length}</Text>
                    </View>
                </View>

                {/* Search Bar */}
                <View style={[styles.searchContainer, { backgroundColor: theme.card, borderColor: theme.border }]}>
                    <Ionicons name="search" size={20} color={theme.subtext} />
                    <TextInput
                        style={[styles.searchInput, { color: theme.text }]}
                        placeholder="Search policy documents..."
                        placeholderTextColor={theme.subtext}
                        value={search}
                        onChangeText={setSearch}
                    />
                    {search.length > 0 && (
                        <TouchableOpacity onPress={() => setSearch('')}>
                            <Ionicons name="close-circle" size={18} color={theme.subtext} />
                        </TouchableOpacity>
                    )}
                </View>

                {/* Categories */}
                <View style={styles.categoryContainer}>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.categoryScroll}>
                        {CATEGORIES.map((cat, index) => (
                            <TouchableOpacity
                                key={index}
                                style={[
                                    styles.categoryChip,
                                    {
                                        backgroundColor: selectedCategory === cat ? theme.primary : theme.card,
                                        borderColor: theme.border,
                                        borderWidth: selectedCategory === cat ? 0 : 1
                                    }
                                ]}
                                onPress={() => setSelectedCategory(cat)}
                            >
                                <Text style={[
                                    styles.categoryText,
                                    { color: selectedCategory === cat ? 'white' : theme.text }
                                ]}>{cat}</Text>
                            </TouchableOpacity>
                        ))}
                    </ScrollView>
                </View>
            </View>

            {/* Document List */}
            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.listContent}>
                {filteredDocs.map((doc, index) => (
                    <Animated.View key={doc.id} entering={FadeInDown.delay(index * 50).duration(400)}>
                        <TouchableOpacity
                            style={[styles.docCard, { backgroundColor: theme.card, borderColor: theme.border }]}
                            onPress={() => handleDownload(doc.title)}
                            activeOpacity={0.7}
                        >
                            <View style={[styles.iconBox, { backgroundColor: theme.primary + '15' }]}>
                                <Ionicons name={doc.icon as any} size={24} color={theme.primary} />
                            </View>
                            <View style={styles.docInfo}>
                                <Text style={[styles.docTitle, { color: theme.text }]} numberOfLines={1}>{doc.title}</Text>
                                <View style={styles.metaRow}>
                                    <Text style={[styles.docMeta, { color: theme.subtext }]}>{doc.category}</Text>
                                    <Text style={[styles.dot, { color: theme.subtext }]}>•</Text>
                                    <Text style={[styles.docMeta, { color: theme.subtext }]}>{doc.size}</Text>
                                    <Text style={[styles.dot, { color: theme.subtext }]}>•</Text>
                                    <Text style={[styles.docMeta, { color: theme.subtext }]}>{doc.date}</Text>
                                </View>
                            </View>
                            <TouchableOpacity onPress={() => handleDownload(doc.title)}>
                                <Ionicons name="download-outline" size={24} color={theme.subtext} />
                            </TouchableOpacity>
                        </TouchableOpacity>
                    </Animated.View>
                ))}

                {filteredDocs.length === 0 && (
                    <View style={styles.emptyState}>
                        <Ionicons name="folder-open-outline" size={48} color={theme.border} />
                        <Text style={[styles.emptyText, { color: theme.subtext }]}>No policies found</Text>
                    </View>
                )}
            </ScrollView>
        </View>
        </SafeAreaView >
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    content: { flex: 1, paddingHorizontal: 20 },
    headerRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginVertical: 16 },
    title: { fontSize: 24, fontWeight: '700' },
    count: { fontSize: 13 },

    // Search
    searchContainer: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, height: 50, borderRadius: 12, borderWidth: 1, marginBottom: 16 },
    searchInput: { flex: 1, marginLeft: 12, fontSize: 15 },

    // Categories
    categoryContainer: { marginBottom: 16 },
    categoryScroll: { paddingRight: 20, gap: 8 },
    categoryChip: { paddingHorizontal: 16, paddingVertical: 8, borderRadius: 20 },
    categoryText: { fontSize: 13, fontWeight: '600' },

    // List
    listContent: { paddingBottom: 100 },
    docCard: { flexDirection: 'row', alignItems: 'center', padding: 16, borderRadius: 16, borderWidth: 1, marginBottom: 12 },
    iconBox: { width: 48, height: 48, borderRadius: 12, alignItems: 'center', justifyContent: 'center', marginRight: 16 },
    docInfo: { flex: 1 },
    docTitle: { fontSize: 15, fontWeight: '600', marginBottom: 4 },
    metaRow: { flexDirection: 'row', alignItems: 'center' },
    docMeta: { fontSize: 12 },
    dot: { marginHorizontal: 4, fontSize: 12 },

    // Empty
    emptyState: { alignItems: 'center', justifyContent: 'center', marginTop: 100 },
    emptyText: { marginTop: 12, fontSize: 14 },
});
