import { BlurView } from 'expo-blur';
import React from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  Image,
  View,
  Animated,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { PanGestureHandler, State } from 'react-native-gesture-handler';

const App = () => {
  return (
    <SafeAreaView>
      <Image
        style={styles.backgroundImage}
        source={require('@/assets/images/bkg.jpg')}
      />
      <Image
        style={styles.backgroundAbstractImage}
        source={require('@/assets/images/abstract.png')}
      />
      <View style={styles.contentContainer}>
        {/* <DraggableBox> */}
        <BlurView
          blurType="light"
          blurAmount={20}
          style={styles.cardContainer}>
          <LinearGradient
            colors={['rgba(0,0,0,0.1)', 'rgba(0,0,0,0.2)']}
            start={{ x: 0, y: 1 }}
            end={{ x: 1, y: 1 }}
            useAngle
            angle={110}
            style={styles.card}
          />
        </BlurView>
        {/* </DraggableBox> */}
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  backgroundImage: {
    height: '100%',
    width: undefined,
    aspectRatio: 1,
    zIndex: 1,
  },
  backgroundAbstractImage: {
    position: 'absolute',
    height: undefined,
    width: '100%',
    aspectRatio: 1,
    zIndex: 5,
    transform: [{ translateY: 200 }, { rotateZ: '-55deg' }, { scale: 1.5 }],
  },
  contentContainer: {
    display: 'flex',
    height: '100%',
    width: '100%',
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
  },
  cardContainer: {
    width: 350,
    height: 200,
  },
  card: {
    height: '100%',
    width: '100%',
    borderColor: 'rgba(255,255,255,0.3)',
    borderRadius: 20,
    borderWidth: 2,
  },
  draggableBox: {
    borderRadius: 20,
    overflow: 'hidden',
  },
});

export default App;