import Ionicons from '@expo/vector-icons/Ionicons';
import { StyleSheet, Image, Platform, Text } from 'react-native';
import Home from '@/components/Home';
import Test from '@/components/Test';
import Organization from '@/components/Organization'

export default function TabTwoScreen() {
  return (

    <Organization />
  );
}

const styles = StyleSheet.create({
  headerImage: {
    color: '#808080',
    bottom: -90,
    left: -35,
    position: 'absolute',
  },
  titleContainer: {
    flexDirection: 'row',
    gap: 8,
  },
});
