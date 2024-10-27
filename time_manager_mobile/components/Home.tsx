import { useRouter } from 'expo-router';
import { ImageBackground, ActivityIndicator, Pressable, Image, StyleSheet, Text as DefaultText, View, Dimensions, ScrollView } from 'react-native';
import axios from 'axios'
import { useEffect, useState } from 'react';
import { jwtDecode } from "jwt-decode";
import { useSession } from './ctx';
import useUserStatsStore from '@/stores/useUserStatsStore';
import { useLocalSearchParams } from 'expo-router'; // Hook fourni par expo-router

export default function HelloWave() {
  const { width: windowWidth, height: windowHeight } = Dimensions.get('window');
  const { session, signOut } = useSession();
  const { refreshQrCode } = useLocalSearchParams(); // Récupérer le paramètre "refresh" à partir de l'URL

  // signOut(); // Déconnexion de l'utilisateur 

  const userId = jwtDecode(session).sub;
  const [userInfo, setUserInfo] = useState(null);
  const [groups, setGroups] = useState(null);
  const [loading, setLoaging] = useState(true);
  const [dayWorkingTime, setDayWorkingTime] = useState(null);
  const { username } = useUserStatsStore();

  console.log("username : ", username);



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
    const response = await axios.get(`http://192.168.1.133:4000/api/users/${userId}`)

    console.log("UUU : ", response.data.user)
    setUserInfo(response.data.user)



  }

  const fetchUserOfOrganization = async () => {
    try {

      const response = await axios.get(`http://192.168.1.133:4000/api/organisations/${userId}/users`)

      console.log("response org: ", response.data);

      setOrganization(response.data)
    } catch (error) {
      console.log("error : ", error);

    }
  }

  const fetchGetUserGroup = async () => {

    try {


      const response = await axios.get(`http://192.168.1.133:4000/api/groups/user/${userId}`)

      console.log("response group: ", response.data.groups);
      if (response.data.groups) {
        setGroups(response.data.groups)
      }
    } catch (error) {
      console.log("error : ", error);
    }
  }

  const getDayWorkingTime = async () => {
    const response = await axios.get(`http://192.168.1.133:4000/api/workingtime/today/${userId}`)

    console.log("response day working time: ", response.data);

    setDayWorkingTime(response.data)
  }

  const getAllData = async () => {
    await fetchGetUserData()
    await fetchUserOfOrganization()
    await fetchGetUserGroup()
    await getDayWorkingTime()
    setLoaging(false)
  }



  useEffect(() => {
    getAllData()
  }, [])

  useEffect(() => {
    if (refreshQrCode) {
      getDayWorkingTime()
    }
  }, [refreshQrCode])

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

  const mapDayWorkingTime = dayWorkingTime && dayWorkingTime.map((time, index) => {

    const startDate = new Date(time.start);
    const startHoursAndMinutes = startDate.toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: false // Pour éviter le format AM/PM
    });

    const formattedDate = startDate.toLocaleDateString('fr-FR');


    const endDate = new Date(time.end);
    const endHoursAndMinutes = endDate.toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: false // Pour éviter le format AM/PM
    });


    return (
      <View key={index} style={[style.glassmorphism, { paddingVertical: 10, paddingHorizontal: 20 }]}>
        <TextOrbitronBold style={{ color: colors.primary, fontSize: 18, marginBottom: 30 }}>{formattedDate}</TextOrbitronBold>
        <Text style={{ fontSize: 16, color: "white" }}>Arrived at <Text style={{ color: colors.primary }}>{startHoursAndMinutes}</Text></Text>
        {time.end && <Text style={{ fontSize: 16, color: "white" }}>Left at <Text style={{ color: colors.primary }}>{endHoursAndMinutes}</Text></Text>}
      </View>
    )
  })



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
            Gotham needs you, <TextOrbitronBold style={{ color: colors.primary }}>{username}</TextOrbitronBold>
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
              Signing of the day
            </TextOrbitronBold>

            {mapDayWorkingTime}

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
