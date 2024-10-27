import React, { useState } from 'react';
import { StyleSheet, Text as DefaultText, View, TextInput, TouchableOpacity, Alert, Dimensions } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useRouter } from 'expo-router';
import { useSession } from "@/components/ctx";

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function ChangePasswordScreen() {
  const router = useRouter();
  const { session } = useSession();
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');

  const handleChangePassword = () => {
    if (!oldPassword || !newPassword) {
      Alert.alert('Erreur', 'Veuillez remplir les deux champs.');
      return;
    }


    Alert.alert(
      'Succès',
      'Votre mot de passe a été changé avec succès.',
      [
        {
          text: 'OK',
          onPress: () => router.goBack(),
        },
      ]
    );
  };

  return (
    <LinearGradient colors={['#000000', '#1c1c1c', '#3e3e3e']} style={styles.backgroundContainer}>
      <View style={styles.contentContainer}>
        <TextOrbitronBold style={styles.headerText}>Changer de mot de passe</TextOrbitronBold>

        <TextInput
          value={oldPassword}
          onChangeText={setOldPassword}
          placeholder="Ancien mot de passe"
          placeholderTextColor="#666"
          secureTextEntry
          style={styles.input}
        />
        <TextInput
          value={newPassword}
          onChangeText={setNewPassword}
          placeholder="Nouveau mot de passe"
          placeholderTextColor="#666"
          secureTextEntry
          style={styles.input}
        />

        <TouchableOpacity style={styles.changeButton} onPress={handleChangePassword}>
          <TextOrbitron style={styles.changeButtonText}>Changer le mot de passe</TextOrbitron>
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
    justifyContent: 'center',
    alignItems: 'center',
  },
  headerText: {
    fontSize: 24,
    color: '#FDCB12',
    marginBottom: 40,
    textAlign: 'center',
  },
  input: {
    width: Dimensions.get('window').width * 0.8,
    padding: 15,
    backgroundColor: '#3e3e3e',
    color: '#FFFFFF',
    borderRadius: 10,
    borderWidth: 1,
    borderColor: '#FDCB12',
    marginBottom: 20,
  },
  changeButton: {
    width: Dimensions.get('window').width * 0.8,
    paddingVertical: 15,
    backgroundColor: '#1c1c1c',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#FDCB12',
  },
  changeButtonText: {
    color: '#FDCB12',
    fontSize: 16,
  },
});
