import { ImageBackground, Image, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView } from 'react-native';

export default function HelloWave() {
  const { width: screenWidth, height: windowHeight } = Dimensions.get('window');

  const colors = {
    primary: "#FDCB12"
  };

  const users = [
    { name: "Paul Durive", isManager: true },
    { name: "Pierre Deloup", isManager: false },
    { name: "Idris Ali", isManager: false },
    { name: "Ali Idris", isManager: false },
    { name: "Sam Sam", isManager: false },
    { name: "John Doe", isManager: false },
    { name: "Jane Doe", isManager: false },
    { name: "Emily Rose", isManager: false }
  ];

  const selectedGroup = ["Paul Durive", "Pierre Deloup", "Idris Ali", "Ali Idris"];

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
        <TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 5 }}>
          Organization
        </TextOrbitronBold>

        {/* Liste des utilisateurs */}
        <View style={{ marginBottom: 40 }}>
          {users.map((user, index) => (
            <View
              key={index}
              style={[
                style.userCard,
              ]}
            >
              <View style={{ flex: 1, flexDirection: 'row' }}>
                <TextBold style={{ color: 'white' }}>
                  {user.name}
                </TextBold>
                {user.isManager && <Image source={require('@/assets/images/bat2.png')} style={{ width: 20, height: 20, marginLeft: 10 }} />}
              </View>
            </View>
          ))}
        </View>

        <TextOrbitronBold style={{ color: 'white', fontSize: 20, marginBottom: 20 }}>
          Groupe
        </TextOrbitronBold>

        {/* Groupe sélectionné */}
        <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
          <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>Groupe A</TextOrbitronBold>
          <Text style={{ marginBottom: 10 }}>
            {selectedGroup.join(" - ")}
          </Text>
          <Text>08:00 - 16:00</Text>
          <Image source={require('../assets/images/bat2.png')} style={style.batImage} />
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
  userCard: {
    padding: 15,
    marginBottom: 15,
    borderRadius: 10,
    backgroundColor: 'rgba(255, 255, 255, 0.4)',

  },
  managerStyle: {


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
