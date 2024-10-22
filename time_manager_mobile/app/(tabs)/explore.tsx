import React from 'react';
import { StyleSheet, Text, View, Image } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { useLocalSearchParams } from 'expo-router';

export default function GothamNeedsYouScreen() {
    // Retrieve the email from the previous screen using params
    const { email } = useLocalSearchParams();

    return (
        <LinearGradient
            colors={['#0000', '#0000', '#3e3e3e']}
            style={styles.backgroundContainer}
        >
            <View style={styles.contentContainer}>
                {/* Display the Title */}
                <Text style={styles.titleText}>Gotham, need you</Text>

                {/* Display the User's Email */}
                <Text style={styles.emailText}>{email}</Text>

                {/* Gotham Image */}
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
        justifyContent: 'center',
        alignItems: 'center',
    },
    titleText: {
        fontSize: 32,
        fontWeight: 'bold',
        color: '#F3F3F3',
        textAlign: 'center',
        marginBottom: 15,
        fontFamily: 'BatmanForeverRegular', // Assume custom font is loaded
    },
    emailText: {
        fontSize: 24,
        color: '#E3B75B',
        textAlign: 'center',
        marginBottom: 30,
        fontFamily: 'Arial',
    },
    gothamImage: {
        width: 300,
        height: 300,
        marginTop: 20,
    },
});
