import { ImageBackground, Image, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView, Pressable } from 'react-native';
import { useLocalSearchParams, useRouter, useSearchParams } from 'expo-router';
import axios from 'axios'
import { useEffect, useState } from 'react';

export default function HelloWave() {
  const { width: screenWidth, height: windowHeight } = Dimensions.get('window');
  let { users, groups } = useLocalSearchParams(); // Récupérer les paramètres passés
  users = JSON.parse(users);
  groups = JSON.parse(groups);
  const [usersGroup, setUsersGroup] = useState(null);
  const router = useRouter();

  console.log("groups in organization : ", groups);

  const navigateToGroup = (group) => {
    router.push({
      pathname: '/organization/group',
      params: {
        group: JSON.stringify(group),
        users: JSON.stringify(usersGroup),
      },
    });
  };

  const fetchGetUsersInGroup = async () => {

    if (!groups) return;
    const groupId = groups[0].id;

    const response = await axios.get(`http://192.168.1.133:4000/api/groups/${groupId}`);

    setUsersGroup(response.data.data.users);


  }

  useEffect(() => {
    fetchGetUsersInGroup()
  }, [])

  // fetchGetUsersInGroup()
  const Text = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Montserrat' }]} />;
  const TextBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'MontserratBold' }]} />;
  const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
  const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

  console.log("users in organization : ", users.length);



  const colors = {
    primary: "#FDCB12"
  };

  const allUsers = users.sort((a, b) => a.role_id - b.role_id).map((user, index) => {
    const isManager = user.role_id === 2;
    console.log("user : ", user);

    return (
      <View
        key={index}
        style={[
          style.userCard,
        ]}
      >
        <View style={{ flex: 1, flexDirection: 'row' }}>
          <TextBold style={{ color: 'white' }}>
            {user.username}
          </TextBold>
          {isManager && <Image source={require('@/assets/images/bat2.png')} style={{ width: 20, height: 20, marginLeft: 10 }} />}
        </View>
      </View>
    )
  })

  const selectedGroup = ["Paul Durive", "Pierre Deloup", "Idris Ali", "Ali Idris"];


  return (
    <ImageBackground source={require('@/assets/images/batground.png')} style={style.container}>
      <ScrollView
        contentContainerStyle={{
          paddingTop: windowHeight * 0.1,
          paddingBottom: windowHeight * 0.1,
          backgroundColor: "rgba(0,0,0,0.6)",
          paddingHorizontal: 20,
          minHeight: windowHeight + 100
        }}
        showsVerticalScrollIndicator={false}
      >
        <TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 5 }}>
          Organization
        </TextOrbitronBold>

        {/* Liste des utilisateurs */}
        <View style={{ marginBottom: 40 }}>
          {allUsers}
        </View>

        {groups && <>
          <TextOrbitronBold style={{ color: 'white', fontSize: 20, marginBottom: 20 }}>
            Groupe
          </TextOrbitronBold>

          <Pressable onPress={() => navigateToGroup(groups[0])} style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
            <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>Groupe A</TextOrbitronBold>
            <Text style={{ marginBottom: 10 }}>
              {selectedGroup.join(" - ")}
            </Text>
            <Text>08:00 - 16:00</Text>
            <Image source={require('../assets/images/bat2.png')} style={style.batImage} />
          </Pressable>
        </>
        }
      </ScrollView>
    </ImageBackground>
  );
}

const style = StyleSheet.create({
  container: {
    flex: 1,
    width: '100%',
    height: '100%',
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
