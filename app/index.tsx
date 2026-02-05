import { LinearGradient } from 'expo-linear-gradient';
import { useRouter } from 'expo-router';
import React, { useState } from 'react';
import { Dimensions, Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import Animated, { FadeInDown, FadeInUp, useAnimatedScrollHandler, useSharedValue } from 'react-native-reanimated';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '@/constants/Colors';
import { useTheme } from '@/context/ThemeContext';

const { width, height } = Dimensions.get('window');

const SLIDES = [
    {
        id: 1,
        title: "Welcome to Recom",
        subtitle: "Your complete employee self-service portal.",
        image: require('@/assets/images/recom-logo.png'),
        isLogo: true,
    },
    {
        id: 2,
        title: "Track Attendance",
        subtitle: "Check in/out seamlessly and view your history.",
        image: require('@/assets/images/onboarding-attendance.png'),
        isLogo: false,
    },
    {
        id: 3,
        title: "Manage Payroll",
        subtitle: "Access payslips and track your earnings.",
        image: require('@/assets/images/onboarding-payroll.png'),
        isLogo: false,
    },
];

export default function WelcomeScreen() {
    const router = useRouter();
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];
    const scrollX = useSharedValue(0);
    const [currentIndex, setCurrentIndex] = useState(0);

    const onScroll = useAnimatedScrollHandler({
        onScroll: (event) => {
            scrollX.value = event.contentOffset.x;
        },
    });

    const handleMomentumScrollEnd = (event: any) => {
        const index = Math.round(event.nativeEvent.contentOffset.x / width);
        setCurrentIndex(index);
    };

    return (
        <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
            <Animated.ScrollView
                horizontal
                pagingEnabled
                showsHorizontalScrollIndicator={false}
                onScroll={onScroll}
                onMomentumScrollEnd={handleMomentumScrollEnd}
                scrollEventThrottle={16}
                bounces={false}
                contentContainerStyle={styles.scrollContent}
            >
                {SLIDES.map((slide, index) => (
                    <View key={slide.id} style={[styles.slide, { width }]}>
                        <Animated.View entering={FadeInUp.delay(200)} style={styles.imageContainer}>
                            <Image
                                source={slide.image}
                                style={[
                                    styles.image,
                                    slide.isLogo && styles.logoImage,
                                    !slide.isLogo && { width: width * 0.8, height: width * 0.8 }
                                ]}
                                resizeMode="contain"
                            />
                        </Animated.View>
                        <Animated.View entering={FadeInDown.delay(400)} style={styles.textContainer}>
                            <Text style={[styles.title, { color: theme.text }]}>{slide.title}</Text>
                            <Text style={[styles.subtitle, { color: theme.subtext }]}>{slide.subtitle}</Text>
                        </Animated.View>
                    </View>
                ))}
            </Animated.ScrollView>

            <View style={styles.footer}>
                {/* Pagination Dots */}
                <View style={styles.pagination}>
                    {SLIDES.map((_, index) => (
                        <View
                            key={index}
                            style={[
                                styles.dot,
                                { backgroundColor: index === currentIndex ? theme.primary : theme.border },
                                index === currentIndex && styles.activeDot
                            ]}
                        />
                    ))}
                </View>

                {/* Action Button */}
                <TouchableOpacity
                    style={[styles.button, { backgroundColor: theme.primary }]}
                    activeOpacity={0.8}
                    onPress={() => router.replace('/auth/login')}
                >
                    <Text style={styles.buttonText}>
                        {currentIndex === SLIDES.length - 1 ? "Get Started" : "Skip to Login"}
                    </Text>
                </TouchableOpacity>
            </View>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1 },
    scrollContent: { alignItems: 'center' },
    slide: { flex: 1, alignItems: 'center', justifyContent: 'center', paddingHorizontal: 20 },
    imageContainer: { flex: 0.6, justifyContent: 'center', alignItems: 'center' },
    image: { width: width * 0.9, height: width * 0.9 },
    logoImage: { width: width * 0.6, height: 100 },
    textContainer: { flex: 0.2, alignItems: 'center', paddingHorizontal: 20 },
    title: { fontSize: 28, fontWeight: '800', textAlign: 'center', marginBottom: 12 },
    subtitle: { fontSize: 16, textAlign: 'center', lineHeight: 24, paddingHorizontal: 20 },
    footer: { flex: 0.2, justifyContent: 'space-between', paddingHorizontal: 24, paddingBottom: 24 },
    pagination: { flexDirection: 'row', justifyContent: 'center', marginBottom: 20 },
    dot: { width: 8, height: 8, borderRadius: 4, marginHorizontal: 4 },
    activeDot: { width: 24, backgroundColor: '#5E35B1' },
    button: { width: '100%', paddingVertical: 18, borderRadius: 16, alignItems: 'center', shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    buttonText: { color: 'white', fontSize: 18, fontWeight: '700' },
});
