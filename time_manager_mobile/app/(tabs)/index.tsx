import React, { useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity, Image, TextInput, KeyboardAvoidingView, Platform, TouchableWithoutFeedback, Keyboard, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { storeToken } from '../../components/asyncStorage'; // Chemin relatif vers asyncStorage.tsx
import {useRouter} from 'expo-router' ; // Utilisation de la route

export default function HomeScreen() {
    const [email, SetEmail] = useState('');
    const [password, SetPassword] = useState('');
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
            console.log('Connexion réussie:', response.data);
            const { token, user } = response.data;
            await storeToken(token);
            Alert.alert('Login Successful', 'You are now logged in!');
            console.log('Connexion réussie:', user);

            router.push({
                pathname: '/explore', // Change this to your new screen's path
                params: { email,userId: user.id,userName: user.username },  // Pass the email as a parameter
            });
        } catch (error) {
            console.error('Erreur lors de la connexion: ', error);
            Alert.alert('Login Failed', 'Please check your email or passward.');
        }
    }; // Ferme correctement la fonction handleLogin

    return (
        <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
            <LinearGradient
                colors={['#3e3e3e', '#E3B75B', '#3e3e3e']}
                style={styles.backgroundContainer}
            >
                <KeyboardAvoidingView
                    behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                    style={styles.backgroundContainer}
                >
                    <View style={styles.titleContainer}>
                        <Text style={styles.titleText}>Be Where Gotham Needs You.</Text>
                        <Text style={styles.subtitleText}>
                            Your role is key in Gotham's pulse. Log in to track your hours, view your schedule, and be a part of the city's heartbeat. The streets are counting on you.
                        </Text>
                    </View>

                    <Image
                        source={require('../../assets/images/logo.png')}
                        style={styles.logo}
                        resizeMode="contain"
                    />

                    <View style={styles.spacer} />

                    <View style={styles.formContainer}>
                        <TextInput
                            placeholder="Email"
                            value={email}
                            onChangeText={SetEmail}
                            style={styles.input}
                            placeholderTextColor="#F3F3F3"
                            keyboardType="email-address"
                            autoCapitalize="none"
                        />
                        <TextInput
                            placeholder="Password"
                            value={password}
                            onChangeText={SetPassword}
                            style={styles.input}
                            placeholderTextColor="#F3F3F3"
                            secureTextEntry
                        />
                        <TouchableOpacity style={styles.signInButton} onPress={handleLogin}>
                            <Text style={styles.buttonText}>Sign In</Text>
                        </TouchableOpacity>
                        <Text style={styles.forgetPasswordText}>
                            Forget Password?
                        </Text>
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
        marginTop: 50, // Adjust as needed
    },
    titleText: {
        fontSize: 28,
        fontWeight: 'bold',
        color: '#F3F3F3', // White or near-white
        textAlign: 'center',
        marginBottom: 15,
        fontFamily: 'BatmanForeverRegular', // Assuming you loaded a custom font
    },
    subtitleText: {
        fontSize: 16,
        color: '#F3F3F3',
        textAlign: 'center',
        marginHorizontal: 20,
        lineHeight: 24,
        fontFamily: 'Arial',
        marginTop: 3, // Adjust as needed
    },
    logo: {
        width: 200,  // Adjust width based on your design
        height: 150, // Adjust height based on your design
        marginBottom: 30,
        marginTop: 50, // Adds spacing between the logo and buttons
    },
    spacer: {
        flex: 1, // Fills space between title and buttons to push buttons to the bottom
    },
    formContainer: {
        width: '100%',
        alignItems: 'center',
        marginBottom: 40,
    },
    input: {
        width: 250,
        height: 50,
        backgroundColor: '#333333',
        borderRadius: 5,
        paddingHorizontal: 15,
        color: '#fff',
        fontSize: 16,
        marginBottom: 20,
        borderWidth: 1,
        borderColor: '#E3B75B',
    },
    signInButton: {
        paddingHorizontal: 30,
        paddingVertical: 10,
        backgroundColor: '#333333', // Dark button background
        borderRadius: 5,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: 20, // Space between button and "Forget Password?" link
        borderWidth: 1,
        borderColor: '#E3B75B', // Matching the yellow tone for the border
    },
    buttonText: {
        color: '#FFF',
        fontSize: 16,
    },
    forgetPasswordText: {
        color: '#E3B75B', // Matching the yellow tone for the link
        fontSize: 14,
        textAlign: 'center',
        textDecorationLine: 'underline', // To underline the text like a hyperlink
    },
});
