import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View, ActivityIndicator, FlatList } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { useLocalSearchParams } from 'expo-router';
import moment from 'moment';

export default function GothamNeedsYouScreen() {
    const { userId, userName } = useLocalSearchParams();  // Utilise userName pour récupérer le nom de l'utilisateur
    const [workingTimes, setWorkingTimes] = useState([]);
    const [loading, setLoading] = useState(true);

    // Function to fetch working times
    const getWorkingTimes = async () => {
        try {
            console.log("Fetching working times for userId:", userId); // Debugging log
            if (!userId) {
                console.error("Error: userId is undefined or null");
                setLoading(false);
                return;
            }
            const response = await axios.get(`http://10.79.216.151:4000/api/workingtimes/${userId}`);
            console.log('Working times fetched:', response.data.data[3]);
            setWorkingTimes(response.data.data);
            setLoading(false);
        } catch (error) {
            console.error('Error fetching working times:', error.response?.data || error.message);
            setLoading(false);
        }
    };

    useEffect(() => {
        getWorkingTimes(); // Fetch working times on component mount
    }, []);

    // Fonction pour formater les dates dans un format lisible
    const formatDateTime = (dateTime) => {
        return moment(dateTime).format('MMMM Do YYYY, h:mm:ss a');
    };

    return (
        <LinearGradient
            colors={['#3e3e3e', '#E3B75B', '#3e3e3e']}
            style={styles.backgroundContainer}
        >
            <View style={styles.contentContainer}>
                <Text style={styles.titleText}>Gotham, need you</Text>
                {/* Remplace l'affichage de l'email par celui du nom d'utilisateur */}
                <Text style={styles.userNameText}>{userName}</Text>

                {loading ? (
                    <ActivityIndicator size="large" color="#E3B75B" />
                ) : (
                    <FlatList
                        data={workingTimes}
                        keyExtractor={(item) => item.id.toString()}
                        renderItem={({ item }) => (
                            <View style={styles.workingTimeItem}>
                                <Text style={styles.workingTimeText}>
                                    Début : {formatDateTime(item.start)}, Fin : {formatDateTime(item.end)}
                                </Text>
                                <Text style={styles.workingTimeText}>
                                    Temps total : {item.total_time ? `${item.total_time} heures` : 'Non disponible'}
                                </Text>
                            </View>
                        )}
                    />
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
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 70,
    },
    titleText: {
        fontSize: 32,
        fontWeight: 'bold',
        color: '#F3F3F3',
        textAlign: 'center',
        marginBottom: 15,
        fontFamily: 'BatmanForeverRegular',
    },
    // Mise à jour pour l'affichage du user_name
    userNameText: {
        fontSize: 24,
        color: '#E3B75B',
        textAlign: 'center',
        marginBottom: 30,
        fontFamily: 'Arial',
    },
    workingTimeItem: {
        backgroundColor: '#333',
        padding: 10,
        marginVertical: 5,
        borderRadius: 5,
        width: '100%',
    },
    workingTimeText: {
        color: '#FFF',
        fontSize: 16,
    },
});
