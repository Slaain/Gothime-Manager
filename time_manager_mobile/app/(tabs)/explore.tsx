import Ionicons from '@expo/vector-icons/Ionicons';
import { StyleSheet, Image, Platform, Text, View } from 'react-native';
import Home from '@/components/Home';
import Test from '@/components/Test';

export default function TabTwoScreen() {
  return (

    <View>
      <Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text><Text style={{ color: "white" }}>
        YO
      </Text>
    </View>
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
