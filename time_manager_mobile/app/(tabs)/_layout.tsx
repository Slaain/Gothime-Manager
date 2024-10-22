import { Tabs } from 'expo-router';
import React from 'react';

import { TabBarIcon } from '@/components/navigation/TabBarIcon';
import { Colors } from '@/constants/Colors';
import { useColorScheme } from '@/hooks/useColorScheme';

export default function TabLayout() {
    const colorScheme = useColorScheme();

    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Colors[colorScheme ?? 'light'].tint,
                headerShown: false,
            }}>
             <Tabs.Screen
                name="index"
                options={{
                    title: 'QR CODE',
                    tabBarIcon: ({ color, focused }) => (
                        <TabBarIcon name={focused ? 'camera' : 'camera-outline'} color={color} />
                    ),
                    tabBarStyle: { display: 'none' }, // Masque la Tab Bar sur l'écran d'accueil
                }}
            />
            <Tabs.Screen
                name="explore"
                options={{
                    title: 'Working Times',
                    tabBarIcon: ({ color, focused }) => (
                        <TabBarIcon name={focused ? 'calendar' : 'calendar-outline'} color={color} />
                    ),
                    // Masque la Tab Bar sur l'écran d'accueil
                }}
            />
        </Tabs>
    );
}
