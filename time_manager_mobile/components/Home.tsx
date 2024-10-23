import { useRouter } from 'expo-router';
import { ImageBackground, ActivityIndicator, Pressable, Image, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView } from 'react-native';
import axios from 'axios'
import { useEffect, useState } from 'react';
export default function HelloWave() {
  const { width: windowWidth, height: windowHeight } = Dimensions.get('window');
  const userId = 1;
  const [userInfo, setUserInfo] = useState(null);
  const [groups, setGroups] = useState(null);
  const [loading, setLoaging] = useState(true);

  const [organization, setOrganization] = useState(null);
  const colors = {
    primary: "#FDCB12"
  };

  const Text = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Montserrat' }]} />;
  const TextBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'MontserratBold' }]} />;
  const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
  const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;
  const router = useRouter();



  const fetchGetUserData = async () => {
    const response = await axios.get(`http://10.79.216.9:4000/api/users/${userId}`)

    console.log("response : ", response.data.user)
    setUserInfo(response.data.user)

  }

  const fetchUserOfOrganization = async () => {
    const response = await axios.get(`http://10.79.216.9:4000/api/organisations/${userId}/users`)
    setOrganization(response.data)
  }

  const fetchGetUserGroup = async () => {

    const response = await axios.get(`http://10.79.216.9:4000/api/groups/user/${userId}`)

    if (response.data.groups) {
      setGroups(response.data.groups)
    }
  }

  const getAllData = async () => {
    await fetchGetUserData()
    await fetchUserOfOrganization()
    await fetchGetUserGroup()
    setLoaging(false)
  }

  useEffect(() => {
    getAllData()
  }, [])

  const mapFirst4Users = () => {

    if (!organization) return
    const allUsers = [];
    for (let i = 0; i < organization.users.length; i++) {
      if (i >= 4) break;

      allUsers.push(organization.users[i].username)

    }

    console.log("allUsers : ", allUsers);


    return allUsers.join(' - ')
  }



  return (
    <ImageBackground source={require('../assets/images/batground.png')} style={style.container}>
      <ScrollView
        contentContainerStyle={{
          paddingTop: windowHeight * 0.1,
          paddingBottom: windowHeight * 0.1,
          backgroundColor: "rgba(0,0,0,0.6)",
          paddingHorizontal: 20,
          minHeight: windowHeight
        }}
        showsVerticalScrollIndicator={false}
      >
        {loading && <ActivityIndicator size="large" color="#FDCB12" />}
        {loading === false &&
          <><TextOrbitronBold style={{ color: 'white', fontSize: 25, marginBottom: 60 }}>
            Gotham needs you, <TextOrbitronBold style={{ color: colors.primary }}>{userInfo && userInfo.username}</TextOrbitronBold>
          </TextOrbitronBold>

            <Pressable
              onPress={() => {
                if (organization) {
                  router.push({
                    pathname: "/organization",
                    params: {
                      users: JSON.stringify(organization.users), // Parameters you want to pass
                      groups: JSON.stringify(groups),
                    },
                  });
                }
              }}
              style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
              <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>{organization && organization.organisation.name} {groups && ` - ${groups[0].name}`}</TextOrbitronBold>
              <Text style={{ marginBottom: 10 }}>{mapFirst4Users()}</Text>
              <Text>08:00 - 12:00</Text>
              <Image source={require('../assets/images/bat2.png')} style={style.batImage} />
            </Pressable>

            <TextOrbitronBold style={{ color: 'white', fontSize: 20, marginBottom: 20 }}>
              Next working days
            </TextOrbitronBold>

            <View style={[style.glassmorphism, { width: "100%", padding: 15, height: 150, overflow: 'hidden' }]}>
              <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>12/10/2024</TextOrbitronBold>
              <Text style={{ marginBottom: 10 }}>{organization && organization.name}}</Text>
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
          </>
        }

      </ScrollView>
    </ImageBackground >
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
