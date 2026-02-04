import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Image, Alert, Dimensions, ImageBackground } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown, FadeInUp } from 'react-native-reanimated';
import { LinearGradient } from 'expo-linear-gradient';
import { useTheme } from '../context/ThemeContext';
import AppHeader from '../components/AppHeader';

const { width } = Dimensions.get('window');

// Mock Data
const PRAYER_TIMES = [
    { name: 'Fajr', time: '05:15 AM' },
    { name: 'Dhuhr', time: '12:30 PM' },
    { name: 'Asr', time: '03:45 PM' },
    { name: 'Maghrib', time: '06:05 PM' },
    { name: 'Isha', time: '07:30 PM' },
];

const CATEGORIES = [
    { id: 1, title: 'Al-Quran', subtitle: 'Read & Listen', icon: 'book', color: '#10B981', type: 'quran' },
    { id: 2, title: 'Hadith', subtitle: 'Sahih Bukhari', icon: 'library', color: '#F59E0B', type: 'hadith' },
    { id: 3, title: 'Duas', subtitle: 'Daily Azkar', icon: 'heart', color: '#EC4899', type: 'dua' },
    { id: 4, title: 'Qibla', subtitle: 'Direction', icon: 'compass', color: '#3B82F6', type: 'qibla' },
    { id: 5, title: 'Tasbih', subtitle: 'Digital Counter', icon: 'finger-print', color: '#8B5CF6', type: 'tasbih' },
    { id: 6, title: 'Zakat', subtitle: 'Calculator', icon: 'calculator', color: '#6366F1', type: 'zakat' },
];

const DAILY_VERSE = {
    arabic: "فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا",
    english: "For indeed, with hardship [will be] ease.",
    ref: "Surah Ash-Sharh (94:5)"
};

export default function IslamicLibraryScreen() {
    const { isDark } = useTheme();
    // Custom theme for this screen - elegant Islamic styling
    const theme = {
        bg: isDark ? '#064E3B' : '#ECFDF5', // Deep emerald dark, light mint light
        card: isDark ? '#065F46' : '#FFFFFF',
        text: isDark ? '#D1FAE5' : '#064E3B',
        accent: '#F59E0B', // Gold
        subtext: isDark ? '#6EE7B7' : '#047857'
    };

    const handlePress = (item: string) => {
        Alert.alert(item, "This feature will be available in the next update.");
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: isDark ? '#022C22' : '#F0FDF4' }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} />

            <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>

                {/* Hero Card - Date & Hijri */}
                <Animated.View entering={FadeInDown.duration(600)} style={styles.heroContainer}>
                    <LinearGradient
                        colors={isDark ? ['#047857', '#064E3B'] : ['#10B981', '#059669']}
                        start={{ x: 0, y: 0 }}
                        end={{ x: 1, y: 1 }}
                        style={styles.heroCard}
                    >
                        <PatternOverlay />
                        <View>
                            <Text style={styles.gregorianDate}>Monday, 02 Feb 2026</Text>
                            <Text style={styles.hijriDate}>15 Shaban, 1447 AH</Text>
                        </View>
                        <View style={styles.moonIcon}>
                            <Ionicons name="moon" size={32} color="#FEF3C7" />
                        </View>
                    </LinearGradient>
                </Animated.View>

                {/* Prayer Times Strip */}
                <View style={styles.prayerStripContainer}>
                    <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.prayerStrip}>
                        {PRAYER_TIMES.map((prayer, index) => (
                            <Animated.View
                                key={prayer.name}
                                entering={FadeInDown.delay(index * 100).duration(400)}
                                style={[
                                    styles.prayerItem,
                                    { backgroundColor: theme.card, borderColor: isDark ? '#047857' : '#D1FAE5' },
                                    prayer.name === 'Dhuhr' && { borderColor: theme.accent, borderWidth: 1 } // Highlight next prayer
                                ]}
                            >
                                <Text style={[styles.prayerName, { color: theme.subtext }]}>{prayer.name}</Text>
                                <Text style={[styles.prayerTime, { color: theme.text }]}>{prayer.time}</Text>
                                {prayer.name === 'Dhuhr' && <View style={[styles.activeDot, { backgroundColor: theme.accent }]} />}
                            </Animated.View>
                        ))}
                    </ScrollView>
                </View>

                {/* Daily Verse */}
                <Animated.View entering={FadeInUp.delay(300).duration(600)} style={[styles.verseCard, { backgroundColor: theme.card }]}>
                    <Text style={[styles.verseLabel, { color: theme.accent }]}>VERSE OF THE DAY</Text>
                    <Text style={[styles.arabicText, { color: theme.text }]}>{DAILY_VERSE.arabic}</Text>
                    <Text style={[styles.englishText, { color: theme.subtext }]}>{DAILY_VERSE.english}</Text>
                    <Text style={[styles.verseRef, { color: theme.accent }]}>{DAILY_VERSE.ref}</Text>
                </Animated.View>

                {/* Feature Grid */}
                <View style={styles.gridContainer}>
                    {CATEGORIES.map((cat, index) => (
                        <Animated.View key={cat.id} entering={FadeInUp.delay(400 + (index * 50)).duration(500)} style={{ width: '48%' }}>
                            <TouchableOpacity
                                style={[styles.catCard, { backgroundColor: theme.card }]}
                                onPress={() => handlePress(cat.title)}
                                activeOpacity={0.8}
                            >
                                <View style={[styles.catIconBox, { backgroundColor: cat.color + '15' }]}>
                                    <Ionicons name={cat.icon as any} size={28} color={cat.color} />
                                </View>
                                <Text style={[styles.catTitle, { color: theme.text }]}>{cat.title}</Text>
                                <Text style={[styles.catSubtitle, { color: theme.subtext }]}>{cat.subtitle}</Text>
                            </TouchableOpacity>
                        </Animated.View>
                    ))}
                </View>

            </ScrollView>
        </SafeAreaView>
    );
}

// Subtle pattern overlay component
const PatternOverlay = () => (
    <View style={StyleSheet.absoluteFill}>
        <Image
            source={{ uri: 'https://www.transparenttextures.com/patterns/arabesque.png' }}
            style={{ width: '100%', height: '100%', opacity: 0.1 }}
            resizeMode="repeat"
        />
    </View>
);

const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { paddingBottom: 100 },

    // Hero
    heroContainer: { padding: 20 },
    heroCard: { padding: 24, borderRadius: 24, flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', overflow: 'hidden', elevation: 10, shadowColor: '#10B981', shadowOpacity: 0.4, shadowRadius: 10, shadowOffset: { width: 0, height: 4 } },
    gregorianDate: { color: 'rgba(255,255,255,0.9)', fontSize: 14, fontWeight: '600', marginBottom: 4 },
    hijriDate: { color: '#ffffff', fontSize: 22, fontWeight: '800', letterSpacing: 0.5 },
    moonIcon: { width: 56, height: 56, borderRadius: 28, backgroundColor: 'rgba(255,255,255,0.2)', alignItems: 'center', justifyContent: 'center' },

    // Prayer Strip
    prayerStripContainer: { marginTop: -10, marginBottom: 20 },
    prayerStrip: { paddingHorizontal: 20, gap: 12 },
    prayerItem: { minWidth: 80, padding: 12, borderRadius: 16, alignItems: 'center', borderWidth: 1, borderBottomWidth: 3 },
    prayerName: { fontSize: 12, fontWeight: '600', marginBottom: 4 },
    prayerTime: { fontSize: 14, fontWeight: '800' },
    activeDot: { position: 'absolute', top: 8, right: 8, width: 6, height: 6, borderRadius: 3 },

    // Verse
    verseCard: { marginHorizontal: 20, padding: 24, borderRadius: 20, alignItems: 'center', marginBottom: 24, shadowColor: "#000", shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 8, elevation: 2 },
    verseLabel: { fontSize: 11, fontWeight: '800', letterSpacing: 1.5, marginBottom: 16 },
    arabicText: { fontSize: 28, fontWeight: '700', marginBottom: 12, textAlign: 'center', fontFamily: 'System' }, // Use a better Arabic font if available
    englishText: { fontSize: 15, textAlign: 'center', fontStyle: 'italic', lineHeight: 22, marginBottom: 8, maxWidth: '90%' },
    verseRef: { fontSize: 12, fontWeight: '600' },

    // Grid
    gridContainer: { flexDirection: 'row', flexWrap: 'wrap', paddingHorizontal: 20, justifyContent: 'space-between', gap: 12 },
    catCard: { padding: 20, borderRadius: 20, alignItems: 'center', shadowColor: "#000", shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 8, elevation: 2 },
    catIconBox: { width: 56, height: 56, borderRadius: 20, alignItems: 'center', justifyContent: 'center', marginBottom: 12 },
    catTitle: { fontSize: 16, fontWeight: '700', marginBottom: 2 },
    catSubtitle: { fontSize: 12, opacity: 0.8 },
});
