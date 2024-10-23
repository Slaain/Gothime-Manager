import React from 'react';
import { StyleSheet, Text as DefaultText, View, TouchableOpacity, Alert, Dimensions } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useRouter, useLocalSearchParams } from 'expo-router'; // Utilisation de la route

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function ProfileScreen() {
    const router = useRouter();
    const { userName } = useLocalSearchParams(); // On récupère l'ID de l'utilisateur depuis les paramètres
    if (!userName) {
        console.error("userName is undefined"); // Ajoutez un log d'erreur
    }
    const handleLogout = () => {
        Alert.alert('Logout', 'Are you sure you want to log out?', [
            { text: 'Cancel', style: 'cancel' },
            {
                text: 'Yes',
                onPress: () => {
                    router.push('/'); // Rediriger vers la page d'accueil après la déconnexion
                },
            },
        ]);
    };

    return (
        <LinearGradient
            colors={['#000000', '#1c1c1c', '#3e3e3e']}
            style={styles.backgroundContainer}
        >
            <View style={styles.contentContainer}>
                <TextOrbitronBold style={styles.welcomeText}>Bonjour, {userName}</TextOrbitronBold>

                {/* Espace pour d'autres informations du profil si nécessaire */}

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
        paddingTop: 50, // Pour aligner le contenu vers le centre
        paddingBottom: 100, // Pour laisser de la place au bouton en bas
    },
    welcomeText: {
        fontSize: 28,
        color: '#FDCB12',
        textAlign: 'center',
        marginBottom: 40,
    },
    logoutButton: {
        position: 'absolute',
        bottom: 40, // Le bouton est fixé en bas
        width: Dimensions.get('window').width * 0.8,
        paddingVertical: 15,
        backgroundColor: '#1c1c1c',
        borderRadius: 10,
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 1,
        borderColor: '#FDCB12',
    },
    logoutButtonText: {
        color: '#FDCB12',
        fontSize: 16,
    },
});
