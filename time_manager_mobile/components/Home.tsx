import { ImageBackground, StyleSheet, Text, View } from 'react-native';

export default function HelloWave() {

  return (
    <ImageBackground source={require('../assets/images/batground.png')} style={style.container}>

      <Text style={{ color: 'white', fontSize: 30, fontWeight: 'bold', marginBottom: 30 }}>Gotham needs you, <Text style={{
        color: 'yellow'
      }}>Paul</Text></Text>
      <View style={style.glassmorphism}>
        <Text style={{ color: 'yellow', fontSize: 30, fontWeight: 'bold' }}>Groupe A</Text>
        <Text style={{ color: 'white', fontSize: 20 }}>08:00 - 12:00</Text>

      </View>

    </ImageBackground >
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',

  },
  glassmorphism: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    width: 230,
    height: 230,
    justifyContent: 'center',
    alignItems: 'center',
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
});
