import React, { useEffect, useState } from 'react';
import { StyleSheet, Text, View, ActivityIndicator, ImageBackground, Dimensions, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { useLocalSearchParams } from 'expo-router';
import moment from 'moment';

export default function GothamNeedsYouScreen() {
    const { userId, userName } = useLocalSearchParams();
    const [workingTimes, setWorkingTimes] = useState([]);
    const [loading, setLoading] = useState(true);

    // Fetch working times
    const getWorkingTimes = async () => {
        try {
            if (!userId) {
                console.error("Error: userId is undefined or null");
                setLoading(false);
                return;
            }
            const response = await axios.get(`http://10.79.216.151:4000/api/workingtimes/${userId}`);
            setWorkingTimes(response.data.data);
            setLoading(false);
        } catch (error) {
            console.error('Error fetching working times:', error.response?.data || error.message);
            setLoading(false);
        }
    };

    useEffect(() => {
        getWorkingTimes();
    }, []);

    // Format date and time
    const formatDateTime = (dateTime) => moment(dateTime).format('DD/MM/YYYY');
    const formatTime = (dateTime) => moment(dateTime).format('HH:mm');

    return (
        <ImageBackground
            source={require('../../assets/images/batground.png')}
            style={styles.backgroundImage}
            resizeMode="cover"
        >
            <ScrollView contentContainerStyle={styles.scrollContainer} showsVerticalScrollIndicator={false}>
                <LinearGradient
                    colors={['#00000080', '#00000080', '#3e3e3e']}
                    style={styles.overlay}
                >
                    <View style={styles.contentContainer}>
                        <Text style={styles.titleText}>Gotham, need you</Text>
                        <Text style={styles.userNameText}>{userName}</Text>
                        <Text style={styles.userNameText}>Your working times</Text>

                        {loading ? (
                            <ActivityIndicator size="large" color="#E3B75B" />
                        ) : (
                            workingTimes.map((item) => (
                                <View key={item.id} style={styles.workingTimeItem}>
                                    <Text style={styles.workingTimeDateText}>
                                        {formatDateTime(item.start)}
                                    </Text>
                                    <Text style={styles.workingTimeGroupText}>Groupe A</Text>
                                    <Text style={styles.workingTimeHourText}>
                                        {formatTime(item.start)} - {formatTime(item.end)}
                                    </Text>
                                    <Text style={styles.workingTimeHourText}>
                                        {item.total_time ? `${item.total_time} heures` : 'Non disponible'}
                                    </Text>
                                </View>
                            ))
                        )}
                    </View>
                </LinearGradient>
            </ScrollView>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    backgroundImage: {
        flex: 1,
        width: Dimensions.get('window').width,
        height: '100%',  // Prendre toute la hauteur de l'écran
    },
    scrollContainer: {
        paddingBottom: 100,  // Ajustement du padding pour éviter les coupures
    },
    overlay: {
        flex: 1,
        justifyContent: 'flex-start',
        alignItems: 'center',
        padding: 20,
    },
    contentContainer: {
        paddingTop: 80,  // Pour éviter que le titre soit coupé
        width: '100%',
        alignItems: 'center',
    },
    titleText: {
        fontSize: 32,
        fontWeight: 'bold',
        color: '#F3F3F3',
        textAlign: 'center',
        marginBottom: 15,
        fontFamily: 'BatmanForeverRegular',
    },
    userNameText: {
        fontSize: 24,
        color: '#E3B75B',
        textAlign: 'center',
        marginBottom: 30,
        fontFamily: 'Arial',
    },
    workingTimeItem: {
        backgroundColor: 'rgba(255, 255, 255, 0.1)',
        padding: 25,
        marginVertical: 15,
        borderRadius: 15,
        borderWidth: 1,
        borderColor: '#E3B75B',
        width: Dimensions.get('window').width * 0.9,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.3,
        shadowRadius: 10,
        elevation: 6,
    },
    workingTimeDateText: {
        color: '#E3B75B',
        fontSize: 20,
        fontWeight: 'bold',
    },
    workingTimeGroupText: {
        color: '#FFF',
        fontSize: 18,
        marginTop: 10,
    },
    workingTimeHourText: {
        color: '#FFF',
        fontSize: 16,
        marginTop: 5,
    },
});
