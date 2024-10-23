import { ImageBackground, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView } from 'react-native';

export default function HelloWave() {
  const { width: screenWidth, height: windowHeight } = Dimensions.get('window');

  const colors = {
    "primary": "#FDCB12"
  }
  const Text = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Montserrat' }]} />;
  const TextBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'MontserratBold' }]} />;
  const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
  const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

  return (
    <ImageBackground source={require('../assets/images/batground.png')} style={style.container}>
      <ScrollView
        contentContainerStyle={[{ paddingTop: windowHeight * 0.1, paddingBottom: (windowHeight * 0.1) + 20, backgroundColor: "rgba(0,0,0,0.6)", width: screenWidth, flex: 1, paddingHorizontal: 20 }]}

      >
        <TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 60 }}>Gotham needs you, <TextOrbitronBold style={{
          color: colors.primary
        }}>Paul</TextOrbitronBold></TextOrbitronBold>
        <View style={[style.glassmorphism, { width: "100%", padding: 15 }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 20, marginBottom: 30 }}>Groupe A</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>Paul Durive - Pierre Deloup - Idris Ali - Ali Idris - Sam Sam</Text>
          <Text style={{}}>08:00 - 12:00</Text>

        </View>
      </ScrollView>
    </ImageBackground >
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    // justifyContent: 'center',
    width: '100%',

  },
  glassmorphism: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    width: 230,
    height: 230,
    // justifyContent: 'center',
    // alignItems: 'center',
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
    filter: 'blur(10)',


  },
});
