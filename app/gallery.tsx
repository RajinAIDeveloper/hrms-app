import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import AppHeader from '../components/AppHeader';
import { Colors } from '../constants/Colors';
import { useTheme } from '../context/ThemeContext';

export default function GalleryScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]} edges={['top']}>
            <AppHeader showBack={true} showLogo={true} />
            <View style={styles.content}>
                <Text style={[styles.title, { color: theme.text }]}>Gallery</Text>
                <Text style={[styles.subtitle, { color: theme.subtext }]}>Coming soon</Text>
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    content: { paddingHorizontal: 20, paddingTop: 16 },
    title: { fontSize: 22, fontWeight: '700' },
    subtitle: { fontSize: 14, marginTop: 6 },
});

