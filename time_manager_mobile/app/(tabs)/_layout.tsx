import { Tabs } from 'expo-router';
import React from 'react';
import { TabBarIcon } from '@/components/navigation/TabBarIcon';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';
import { getFocusedRouteNameFromRoute } from '@react-navigation/native';

function getTabBarVisibility(route) {
    const routeName = getFocusedRouteNameFromRoute(route) ?? '';

    // Si vous souhaitez masquer la barre d'onglets pour certains écrans
    if (routeName === 'Camera') {
        return false;
    }
    return true;
}

export default function TabLayout() {
    const colorScheme = useColorScheme();

    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Colors[colorScheme ?? 'light'].tint,
                headerShown: false,
            }}
        >
            <Tabs.Screen
                name="Camera"
                options={({ route }) => ({
                    title: 'QR CODE',
                    tabBarIcon: ({ color, focused }) => (
                        <TabBarIcon name={focused ? 'camera' : 'camera-outline'} color={color} />
                    ),
                    tabBarVisible: getTabBarVisibility(route),
                })}
            />
            <Tabs.Screen
                name="explore"
                options={({ route }) => ({
                    title: 'Working Times',
                    tabBarIcon: ({ color, focused }) => (
                        <TabBarIcon name={focused ? 'calendar' : 'calendar-outline'} color={color} />
                    ),
                    tabBarVisible: getTabBarVisibility(route),
                })}
            />

        </Tabs>
    );
}
