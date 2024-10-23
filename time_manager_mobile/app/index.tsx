import React, { useState } from 'react';
import { StyleSheet, Text as DefaultText, View, TouchableOpacity, Image, TextInput, KeyboardAvoidingView, Platform, TouchableWithoutFeedback, Keyboard, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { storeToken } from '../components/asyncStorage'; // Chemin relatif vers asyncStorage.tsx
import { useRouter } from 'expo-router'; // Utilisation de la route

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function HomeScreen() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const router = useRouter();

    const handleLogin = async () => {
        try {
            const response = await axios.post('http://10.79.216.151:4000/api/login', {
                email,
                password,
            }, {
                headers: {
                    'Content-Type': 'application/json',
                }
            });
            const { token, user } = response.data;
            await storeToken(token);
            Alert.alert('Login Successful', 'You are now logged in!');

            router.push({
                pathname: '/explore', // Change this to your new screen's path
                params: { email, userId: user.id, userName: user.username },  // Pass the email as a parameter
            });
            console.log("userName is " + user.username);
        } catch (error) {
            console.error('Erreur lors de la connexion: ', error);
            Alert.alert('Login Failed', 'Please check your email or password.');
        }
    };

    return (
        <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
            <LinearGradient
                colors={['#000000', '#1c1c1c', '#3e3e3e']}
                style={styles.backgroundContainer}
            >
                <KeyboardAvoidingView
                    behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                    style={styles.backgroundContainer}
                >
                    <View style={styles.titleContainer}>
                        <TextOrbitronBold style={styles.titleText}>Gotham Needs You</TextOrbitronBold>
                        <TextOrbitron style={styles.subtitleText}>
                            Join Gotham's pulse. Log in to track your hours and schedule, and be a key part of the city's heartbeat.
                        </TextOrbitron>
                    </View>

                    <Image
                        source={require('../assets/images/logo.png')}
                        style={styles.logo}
                        resizeMode="contain"
                    />

                    <View style={styles.formContainer}>
                        <TextInput
                            placeholder="Email"
                            value={email}
                            onChangeText={setEmail}
                            style={styles.input}
                            placeholderTextColor="#F3F3F3"
                            keyboardType="email-address"
                            autoCapitalize="none"
                        />
                        <TextInput
                            placeholder="Password"
                            value={password}
                            onChangeText={setPassword}
                            style={styles.input}
                            placeholderTextColor="#F3F3F3"
                            secureTextEntry
                        />
                        <TouchableOpacity style={styles.signInButton} onPress={handleLogin}>
                            <TextOrbitron style={styles.buttonText}>Sign In</TextOrbitron>
                        </TouchableOpacity>
                        <TextOrbitron style={styles.forgetPasswordText}>
                            Forget Password?
                        </TextOrbitron>
                    </View>
                </KeyboardAvoidingView>
            </LinearGradient>
        </TouchableWithoutFeedback>
    );
}

const styles = StyleSheet.create({
    backgroundContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
    },
    titleContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        marginBottom: 30,
        marginTop: 50,
    },
    titleText: {
        fontSize: 30,
        color: '#FDCB12',
        textAlign: 'center',
        marginBottom: 15,
    },
    subtitleText: {
        fontSize: 16,
        color: '#F3F3F3',
        textAlign: 'center',
        marginHorizontal: 20,
        lineHeight: 24,
    },
    logo: {
        width: 180,
        height: 180,
        marginBottom: 30,
        marginTop: 50,
    },
    formContainer: {
        width: '100%',
        alignItems: 'center',
        marginBottom: 40,
    },
    input: {
        width: 280,
        height: 50,
        backgroundColor: '#333333',
        borderRadius: 10,
        paddingHorizontal: 15,
        color: '#fff',
        fontSize: 16,
        marginBottom: 20,
        borderWidth: 1,
        borderColor: '#FDCB12',
    },
    signInButton: {
        paddingHorizontal: 30,
        paddingVertical: 12,
        backgroundColor: '#1c1c1c',
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
    forgetPasswordText: {
        color: '#FDCB12',
        fontSize: 14,
        textAlign: 'center',
        textDecorationLine: 'underline',
    },
});
