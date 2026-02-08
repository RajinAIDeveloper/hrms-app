import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Image, Alert, KeyboardAvoidingView, Platform, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors } from '@/constants/Colors';
import { Ionicons } from '@expo/vector-icons';
import Animated, { FadeInDown, FadeInUp } from 'react-native-reanimated';
import { useTheme } from '@/context/ThemeContext';
import { useAuth } from '@/context/AuthContext';

export default function LoginScreen() {
    const { isDark } = useTheme();
    const theme = Colors[isDark ? 'dark' : 'light'];
    const { login } = useAuth();

    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [showPassword, setShowPassword] = useState(false);

    const handleLogin = async () => {
        setError('');

        // Validation
        if (!username.trim()) {
            setError('Username is required');
            return;
        }
        if (password.length < 6) {
            setError('Password must be at least 6 characters');
            return;
        }

        setLoading(true);
        try {
            await login(username, password);
            // AuthContext handles navigation to /(tabs)
        } catch (err: any) {
            setError(err.message || 'Login failed. Please try again.');
        } finally {
            setLoading(false);
        }
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
                    {error ? (
                        <View style={[styles.errorContainer, { backgroundColor: isDark ? '#7F1D1D' : '#FEE2E2', borderColor: isDark ? '#991B1B' : '#FCA5A5' }]}>
                            <Ionicons name="alert-circle" size={20} color={isDark ? '#FCA5A5' : '#DC2626'} />
                            <Text style={[styles.errorText, { color: isDark ? '#FCA5A5' : '#DC2626' }]}>{error}</Text>
                        </View>
                    ) : null}

                    <View style={styles.inputGroup}>
                        <Text style={[styles.label, { color: theme.text }]}>Username</Text>
                        <TextInput
                            style={[styles.input, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                            placeholder="demo_user"
                            placeholderTextColor={theme.subtext}
                            value={username}
                            onChangeText={setUsername}
                            autoCapitalize="none"
                            editable={!loading}
                        />
                    </View>

                    <View style={styles.inputGroup}>
                        <Text style={[styles.label, { color: theme.text }]}>Password</Text>
                        <View style={styles.passwordContainer}>
                            <TextInput
                                style={[styles.input, styles.passwordInput, { backgroundColor: theme.card, borderColor: theme.border, color: theme.text }]}
                                placeholder="••••••••"
                                placeholderTextColor={theme.subtext}
                                value={password}
                                onChangeText={setPassword}
                                secureTextEntry={!showPassword}
                                editable={!loading}
                            />
                            <TouchableOpacity
                                style={styles.eyeIcon}
                                onPress={() => setShowPassword(!showPassword)}
                            >
                                <Ionicons
                                    name={showPassword ? 'eye-off' : 'eye'}
                                    size={20}
                                    color={theme.subtext}
                                />
                            </TouchableOpacity>
                        </View>
                    </View>

                    <TouchableOpacity onPress={() => Alert.alert("Forgot Password", "Contact IT support.")}>
                        <Text style={[styles.forgotText, { color: theme.primary }]}>Forgot Password?</Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[styles.loginButton, { backgroundColor: theme.primary, opacity: loading ? 0.7 : 1 }]}
                        onPress={handleLogin}
                        activeOpacity={0.8}
                        disabled={loading}
                    >
                        {loading ? (
                            <ActivityIndicator size="small" color="white" />
                        ) : (
                            <Text style={styles.loginButtonText}>Login</Text>
                        )}
                    </TouchableOpacity>

                    <Text style={[styles.hintText, { color: theme.subtext }]}>
                        Demo: demo_user / Demo@2024
                    </Text>
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
    errorContainer: { flexDirection: 'row', alignItems: 'center', gap: 8, padding: 12, borderRadius: 12, marginBottom: 16, borderWidth: 1 },
    errorText: { flex: 1, fontSize: 14, fontWeight: '500' },
    inputGroup: { marginBottom: 20 },
    label: { fontSize: 14, fontWeight: '600', marginBottom: 8 },
    input: { padding: 16, borderRadius: 12, borderWidth: 1, fontSize: 16 },
    passwordContainer: { position: 'relative' },
    passwordInput: { paddingRight: 50 },
    eyeIcon: { position: 'absolute', right: 16, top: 16 },
    forgotText: { alignSelf: 'flex-end', fontSize: 14, fontWeight: '600', marginBottom: 24 },
    loginButton: { paddingVertical: 18, borderRadius: 14, alignItems: 'center', justifyContent: 'center', shadowColor: '#5E35B1', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.3, shadowRadius: 8, elevation: 8 },
    loginButtonText: { color: 'white', fontSize: 16, fontWeight: '700' },
    hintText: { textAlign: 'center', fontSize: 13, marginTop: 16, fontStyle: 'italic' },
});
