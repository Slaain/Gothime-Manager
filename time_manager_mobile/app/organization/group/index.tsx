import { useLocalSearchParams, useNavigation } from 'expo-router';
import { ImageBackground, ScrollView, View, Text as DefaultText, Image, StyleSheet, Dimensions, Platform, StatusBar } from 'react-native';
import { AntDesign } from '@expo/vector-icons';
export default function GroupDetails() {
  let { group, users } = useLocalSearchParams();
  group = JSON.parse(group);
  users = JSON.parse(users);
  const { width: screenWidth, height: windowHeight } = Dimensions.get('window');
  const navigation = useNavigation();

  const Text = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Montserrat' }]} />;
  const TextBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'MontserratBold' }]} />;
  const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
  const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

  const colors = { primary: "#FDCB12" };

  const allUsers = users.map((user, index) => (
    <View key={index} style={style.userCard}>
      <View style={{ flex: 1, flexDirection: 'row' }}>
        <TextBold style={{ color: 'white' }}>{user.username}</TextBold>
      </View>
    </View>
  ));

  return (
    <ImageBackground source={require('@/assets/images/batground.png')} style={style.container}>
      <ScrollView contentContainerStyle={{
        paddingTop: windowHeight * 0.1,
        paddingBottom: windowHeight * 0.1,
        backgroundColor: "rgba(0,0,0,0.6)",
        paddingHorizontal: 20,
        minHeight: windowHeight + 100
      }}>
        <AntDesign
          name="arrowleft"
          size={26}
          color="white"
          style={{ top: Platform.OS === "android" ? StatusBar.currentHeight + 15 : 15, position: 'absolute', left: 15, top: 50 }}
          onPress={() => navigation.goBack()}
        />
        <TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 30 }}>{group.name}</TextOrbitronBold>
        {allUsers}
      </ScrollView>
    </ImageBackground>
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    width: '100%',
  },
  userCard: {
    padding: 15,
    marginBottom: 15,
    borderRadius: 10,
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
  },
});
