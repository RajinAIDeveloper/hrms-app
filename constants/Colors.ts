/**
 * Recom Corporate Theme Updated
 * Based on provided Login UI:
 * - Primary Button/Brand: Deep Purple/Indigo (#5E35B1)
 * - Secondary Brand: Recom Red (#E53935) & Blue (#1E88E5)
 * - Backgrounds: Clean White/Gray
 */

const tintColorLight = '#5E35B1'; // Deep Purple from button
const tintColorDark = '#9575CD';

export const Colors = {
    light: {
        text: '#1F2937',        // Gray-900 (Softer black)
        background: '#F9FAFB',  // Gray-50 (Modern clean bg)
        tint: tintColorLight,
        icon: '#6B7280',        // Gray-500
        tabIconDefault: '#9CA3AF', // Gray-400
        tabIconSelected: tintColorLight,

        // Recom Specific
        recomBlue: '#0056D2',   // Logo Blue
        recomRed: '#D32F2F',    // Logo Red
        primary: '#5E35B1',     // Main Action Purple

        // Semantic
        success: '#10B981',     // Emerald-500
        warning: '#F59E0B',     // Amber-500
        error: '#EF4444',       // Red-500
        info: '#3B82F6',        // Blue-500

        // UI Elements
        card: '#FFFFFF',
        border: '#E5E7EB',      // Gray-200
        subtext: '#6B7280',     // Gray-500
        ripple: 'rgba(94, 53, 177, 0.1)', // Purple ripple
    },
    dark: {
        text: '#F9FAFB',
        background: '#111827',  // Gray-900
        tint: tintColorDark,
        icon: '#9CA3AF',
        tabIconDefault: '#6B7280',
        tabIconSelected: tintColorDark,

        // Recom Specific
        recomBlue: '#60A5FA',
        recomRed: '#EF5350',
        primary: '#7C4DFF',     // Lighter purple

        // Semantic
        success: '#34D399',
        warning: '#FBBF24',
        error: '#F87171',
        info: '#60A5FA',

        // UI Elements
        card: '#1F2937',        // Gray-800
        border: '#374151',      // Gray-700
        subtext: '#9CA3AF',
        ripple: 'rgba(124, 77, 255, 0.1)',
    },
};
