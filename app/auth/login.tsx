import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image, Alert, KeyboardAvoidingView, Platform } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '@/constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown, FadeInUp } from 'react-native-reanimated';
import { useColorScheme } from '@/hooks/use-color-scheme';
import { router } from 'expo-router';

export default function LoginScreen() {
    const colorScheme = useColorScheme();
    const theme = Colors[colorScheme ?? 'light'];

    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);

    const handleLogin = () => {
        if (!email || !password) {
            Alert.alert("Error", "Please enter valid credentials.");
            return;
        }
        setLoading(true);
        setTimeout(() => {
            setLoading(false);
            router.replace('/(tabs)');
        }, 1500);
    };

    return (
        <KeyboardAvoidingView behavior={Platform.OS === 'ios' ? 'padding' : 'height'} style={{ flex: 1 }}>
            <SafeAreaView style={[styles.container, { backgroundColor: theme.background }]}>
                <Animated.View entering={FadeInUp.duration(600)} style={styles.logoContainer}>
                    <Image
                        source={require('@/assets/images/recom-logo.png')}
                        style={styles.logo}
                        resizeMode="contain"
                    />
                    <Text style={[styles.subtitle, { color: theme.subtext }]}>Employee Self Service</Text>
                </Animated.View>

                <Animated.View entering={FadeInDown.delay(200).duration(600)} style={styles.formContainer}>
                    <View style={styles.inputGroup}>
                        <Text style={[styles.label, { color: theme.text }]}>Work Email</Text>
                        <TextInput
                            style={[styles.input, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                            placeholder="rahim@recom.com"
                            placeholderTextColor={theme.subtext}
                            value={email}
                            onChangeText={setEmail}
                            autoCapitalize="none"
                            keyboardType="email-address"
                        />
                    </View>

                    <View style={styles.inputGroup}>
                        <Text style={[styles.label, { color: theme.text }]}>Password</Text>
                        <TextInput
                            style={[styles.input, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                            placeholder="••••••••"
                            placeholderTextColor={theme.subtext}
                            value={password}
                            onChangeText={setPassword}
                            secureTextEntry
                        />
                    </View>

                    <TouchableOpacity onPress={() => Alert.alert("Forgot Password", "Contact IT support.")}>
                        <Text style={[styles.forgotText, { color: theme.primary }]}>Forgot Password?</Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[styles.loginButton, { backgroundColor: theme.primary }]}
                        onPress={handleLogin}
                        activeOpacity={0.8}
                    >
                        {loading ? (
                            <Ionicons name="reload" size={24} color="white" />
                        ) : (
                            <Text style={styles.loginButtonText}>Login</Text>
                        )}
                    </TouchableOpacity>
                </Animated.View>
            </SafeAreaView>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, justifyContent: 'center' },
    logoContainer: { alignItems: 'center', marginBottom: 40 },
    logo: { width: 180, height: 60 },
    subtitle: { fontSize: 16, marginTop: 8 },
    formContainer: { paddingHorizontal: 32 },
    inputGroup: { marginBottom: 20 },
    label: { fontSize: 14, fontWeight: '600', marginBottom: 8 },
    input: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 16 },
    forgotText: { alignSelf: 'flex-end', fontSize: 14, fontWeight: '600', marginBottom: 24 },
    loginButton: { paddingVertical: 18, borderRadius: 14, alignItems: 'center', justifyContent: 'center', shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    loginButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },
});
