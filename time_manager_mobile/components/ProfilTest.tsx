import React from 'react';
import { StyleSheet, Text as DefaultText, View, TouchableOpacity, Alert, Dimensions, Image } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { useSession } from "@/components/ctx";
import useUserStatsStore from '@/stores/useUserStatsStore';
import { jwtDecode } from "jwt-decode";

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function ProfileScreen() {
  const router = useRouter();
  const { signOut, session } = useSession();
  const { username, email, resetStats } = useUserStatsStore();

  const userId = jwtDecode(session).sub;

  // Log out function
  const handleLogout = () => {
    Alert.alert('Logout', 'Are you sure you want to log out?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Yes',
        onPress: () => {
          router.push('/sign-in');
          signOut();
          resetStats();
        },
      },
    ]);
  };

  // Navigate to change password
  const goToChangePassword = () => {
    router.push('/profil/updatePassword');
  };

  return (
    <LinearGradient colors={['#000000', '#1c1c1c', '#3e3e3e']} style={styles.backgroundContainer}>
      <View style={styles.contentContainer}>
        <Image
          source={{ uri: 'https://www.example.com/path-to-profile-pic.jpg' }} // Replace with user's actual profile picture
          style={styles.profilePicture}
        />
        <TextOrbitronBold style={styles.welcomeText}>Bonjour, {username}</TextOrbitronBold>
        <TextOrbitron style={styles.emailText}>{email}</TextOrbitron>

        {/* Change Password Button */}
        <TouchableOpacity style={styles.button} onPress={goToChangePassword}>
          <TextOrbitron style={styles.buttonText}>Changer de mot de passe</TextOrbitron>
        </TouchableOpacity>

        {/* Logout Button */}
        <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
          <TextOrbitron style={styles.logoutButtonText}>Se déconnecter</TextOrbitron>
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  backgroundContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  contentContainer: {
    width: '100%',
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 50,
    paddingBottom: 100,
  },
  profilePicture: {
    width: 120,
    height: 120,
    borderRadius: 60,
    marginBottom: 20,
    borderWidth: 2,
    borderColor: '#FDCB12',
  },
  welcomeText: {
    fontSize: 28,
    color: '#FDCB12',
    textAlign: 'center',
    marginBottom: 5,
  },
  emailText: {
    fontSize: 16,
    color: '#CCCCCC',
    marginBottom: 40,
  },
  button: {
    width: Dimensions.get('window').width * 0.8,
    paddingVertical: 15,
    backgroundColor: '#3e3e3e',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
    borderWidth: 1,
    borderColor: '#FDCB12',
  },
  buttonText: {
    color: '#FDCB12',
    fontSize: 16,
  },
  logoutButton: {
    width: Dimensions.get('window').width * 0.8,
    paddingVertical: 15,
    backgroundColor: '#1c1c1c',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#FDCB12',
    position: 'absolute',
    bottom: 40,
  },
  logoutButtonText: {
    color: '#FDCB12',
    fontSize: 16,
  },
});
