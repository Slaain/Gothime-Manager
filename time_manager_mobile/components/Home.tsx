import { ImageBackground, Image, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView } from 'react-native';

export default function HelloWave() {
  const { width: screenWidth, height: windowHeight } = Dimensions.get('window');

  const colors = {
    primary: "#FDCB12"
  };

  const Text = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Montserrat' }]} />;
  const TextBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'MontserratBold' }]} />;
  const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
  const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

  return (
    <ImageBackground source={require('../assets/images/batground.png')} style={style.container}>
      <ScrollView
        contentContainerStyle={{
          paddingTop: windowHeight * 0.1,
          paddingBottom: windowHeight * 0.1,
          backgroundColor: "rgba(0,0,0,0.6)",
          paddingHorizontal: 20,
        }}
        showsVerticalScrollIndicator={false}
      >
        <TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 60 }}>
          Gotham needs you, <TextOrbitronBold style={{ color: colors.primary }}>Paul</TextOrbitronBold>
        </TextOrbitronBold>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150 }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>Groupe A</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Paul Durive - Pierre Deloup - Idris Ali - Ali Idris - Sam Sam</Text>
          <Text>08:00 - 12:00</Text>
          <Image source={require('../assets/images/bat2.png')} style={style.batImage} />
        </View>

        <TextOrbitronBold style={{ color: 'white', fontSize: 20, marginBottom: 20 }}>
          Next working days
        </TextOrbitronBold>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>

        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Groupe A</Text>
          <Text style={{}}>08:00 - 16:00</Text>

          <Image source={require('../assets/images/bat2.png')} style={{ width: 90, height: 90, position: 'absolute', right: -28, bottom: -28, opacity: 0.7, transform: [{ rotate: '-45deg' }] }} />
        </View>


      </ScrollView>
    </ImageBackground>
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    width: '100%',
  },
  glassmorphism: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    borderRadius: 15,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 1)',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 10,
    },
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 10,
    marginBottom: 30,
  },
  batImage: {
    width: 90,
    height: 90,
    position: 'absolute',
    right: -28,
    bottom: -28,
    opacity: 0.7,
    transform: [{ rotate: '-45deg' }],
  },
});
