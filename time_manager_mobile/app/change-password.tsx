import React, { useState } from 'react';
import { StyleSheet, Text as DefaultText, View, TextInput, TouchableOpacity, Alert, Dimensions, Platform, StatusBar } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useNavigation, useRouter } from 'expo-router';
import { AntDesign } from '@expo/vector-icons';
import axios from 'axios';
import { useSession } from '@/components/ctx';

import { jwtDecode } from 'jwt-decode';

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function ResetPasswordScreen() {
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [email, setEmail] = useState('');
  const [code, setCode] = useState('');
  const [newPassword, setNewPassword] = useState('');

  const [userId, setUserId] = useState(null);
  const [tokenForChangePassword, setTokenForChangePassword] = useState(null);


  const sendMail = async () => {
    try {

      await axios.post("https://time-manager-sendmail.vercel.app/request-password-change", {
        email: email
      })











      setStep(2)
    } catch (error) {
      console.log("error : ", error);


    }
  }
  const handleEmailSubmit = () => {
    if (!email) {
      Alert.alert('Erreur', 'Veuillez entrer une adresse e-mail.');
      return;
    }

    Alert.alert(
      'Code envoyé',
      'Si un compte existe avec cet e-mail, un code de vérification vous a été envoyé.',
      [
        {
          text: 'OK',
          onPress: () => sendMail(), // Passage à l’étape 2
        },
      ]
    );
  };

  console.log("tokenForChangePassword : ", tokenForChangePassword);

  const handleCodeSubmit = async () => {
    if (code.length !== 6) {
      Alert.alert('Erreur', 'Veuillez entrer un code de 6 chiffres.');
      return;
    }

    const response = await axios.post("https://time-manager-sendmail.vercel.app/confirm-password-change", {
      verificationCode: code
    })

    console.log("response.data.result : ", response.data.result);

    if (response.data.result) {
      // try {
      console.log("yo");

      const responseUserId = await axios.get(`http://10.79.216.9:4000/api/users/by_email/${email}`)

      console.log("responseUserId : ", responseUserId.data.user_id);

      setUserId(responseUserId.data.user_id)



      const response = await axios.get(`http://10.79.216.9:4000/api/mail_token/${responseUserId.data.user_id}`)
      console.log("response : ", response);

      setTokenForChangePassword(response.data.token)
      setStep(3)
      return;
      // } catch (error) {
      //   console.log("error : ", error);
      //   Alert.alert('Erreur', 'Aucun compte n\'a été trouvé avec cet e-mail.');
      // }

    }
  };

  const handleChangePassword = async () => {
    if (!newPassword) {
      Alert.alert('Erreur', 'Veuillez entrer un nouveau mot de passe.');
      return;
    }


    await axios.put(`http://10.79.216.9:4000/api/users/update_password_with_token/${userId}`, {
      token: tokenForChangePassword,
      new_password: newPassword
    })

    Alert.alert(
      'Succès',
      'Votre mot de passe a été changé avec succès.',
      [
        {
          text: 'OK',
          onPress: () => router.push('/sign-in'), // Redirige vers la page de connexion
        },
      ]
    );
  };

  const navigation = useNavigation();

  return (
    <LinearGradient colors={['#000000', '#1c1c1c', '#3e3e3e']} style={styles.backgroundContainer}>
      <View style={styles.contentContainer}>
        <AntDesign
          name="arrowleft"
          size={26}
          color="white"
          style={{ top: Platform.OS === "android" ? StatusBar.currentHeight + 15 : 15, position: 'absolute', left: 15, top: 50 }}
          onPress={() => navigation.goBack()}
        />
        {step === 1 && (
          <>
            <TextOrbitronBold style={styles.headerText}>Entrez votre e-mail</TextOrbitronBold>
            <TextInput
              value={email}
              onChangeText={setEmail}
              placeholder="E-mail"
              placeholderTextColor="#666"
              keyboardType="email-address"
              style={styles.input}
            />
            <TouchableOpacity style={styles.submitButton} onPress={handleEmailSubmit}>
              <TextOrbitron style={styles.submitButtonText}>Envoyer</TextOrbitron>
            </TouchableOpacity>
          </>
        )}

        {step === 2 && (
          <>
            <TextOrbitronBold style={styles.headerText}>Entrez le code de vérification</TextOrbitronBold>
            <TextInput
              value={code}
              onChangeText={setCode}
              placeholder="Code à 6 chiffres"
              placeholderTextColor="#666"
              keyboardType="numeric"
              maxLength={6}
              style={styles.input}
            />
            <TouchableOpacity style={styles.submitButton} onPress={handleCodeSubmit}>
              <TextOrbitron style={styles.submitButtonText}>Valider</TextOrbitron>
            </TouchableOpacity>
          </>
        )}

        {step === 3 && (
          <>
            <TextOrbitronBold style={styles.headerText}>Nouveau mot de passe</TextOrbitronBold>
            <TextInput
              value={newPassword}
              onChangeText={setNewPassword}
              placeholder="Nouveau mot de passe"
              placeholderTextColor="#666"
              secureTextEntry
              style={styles.input}
            />
            <TouchableOpacity style={styles.submitButton} onPress={handleChangePassword}>
              <TextOrbitron style={styles.submitButtonText}>Changer le mot de passe</TextOrbitron>
            </TouchableOpacity>
          </>
        )}
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
    height: '100%',
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
  submitButton: {
    width: Dimensions.get('window').width * 0.8,
    paddingVertical: 15,
    backgroundColor: '#1c1c1c',
    borderRadius: 10,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#FDCB12',
  },
  submitButtonText: {
    color: '#FDCB12',
    fontSize: 16,
  },
});
