import { Redirect, Tabs, usePathname } from 'expo-router';
import React from 'react';
import { TabBarIcon } from '@/components/navigation/TabBarIcon';
import { useColorScheme } from '@/hooks/useColorScheme';
import { AntDesign, Entypo, Ionicons } from '@expo/vector-icons';
import MyTabBar from '@/components/MyTabBar';
import { Text } from 'react-native';
import { useSession } from '@/components/ctx';

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const pathname = usePathname();
  const colors = { primary: "#FDCB12" };

  const { session, isLoading } = useSession();


  if (isLoading) return <Text>Loading...</Text>;

  if (!session) {
    // On web, static rendering will stop here as the user is not authenticated
    // in the headless Node process that the pages are rendered in.
    return <Redirect href="/sign-in" />;
  }

  console.log("pathname : ", pathname);

  return (
    <Tabs
      tabBar={props => <MyTabBar {...props} pathname={pathname} />}
      screenOptions={({ route }) => ({


        tabBarIcon: ({ focused, color, size }) => {
          if (route.name === 'index') {
            return <Entypo name="home" size={24} color={pathname === '/' ? colors.primary : 'black'} />
          } else if (route.name === 'camera') {
            return <AntDesign name="camera" size={24} color={pathname === '/camera' ? colors.primary : 'black'} />
          } else if (route.name === 'explore') {
            return <Ionicons name="stats-chart" size={24} color={pathname === '/explore' ? colors.primary : 'black'} />
          }
        },
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: 'gray',
        headerShown: false, // Cacher le header
      })}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Home',

        }}
      />
      <Tabs.Screen
        name="camera"
        options={{
          title: 'Camera',

        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: 'Explore',

        }}
      />

    </Tabs>
  );
}
