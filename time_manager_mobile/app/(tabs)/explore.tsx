import React, { useEffect, useState } from 'react';
import { StyleSheet, Text as DefaultText, View, ActivityIndicator, ImageBackground, Dimensions, ScrollView, Pressable, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { BarChart } from 'react-native-chart-kit';
import { useLocalSearchParams, useRouter } from 'expo-router';
import moment from 'moment';
import Icon from 'react-native-vector-icons/Ionicons'; // Import Icon

// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function GothamNeedsYouScreen() {
    const { userId, userName } = useLocalSearchParams();
    const [workingTimes, setWorkingTimes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [chartData, setChartData] = useState({ labels: [], durations: [] });
    const [viewMode, setViewMode] = useState('day');
    const router = useRouter(); // Utilisation de router pour redirection

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
            processChartData(response.data.data, 'day'); // Process initial data
        } catch (error) {
            console.error('Error fetching working times:', error.response?.data || error.message);
            setLoading(false);
        }
    };

    useEffect(() => {
        getWorkingTimes();
    }, []);

    // Process chart data depending on view mode (day, week, month)
    const processChartData = (data, mode) => {
        let groupedData = {};
        data.forEach(item => {
            let dateKey;
            switch (mode) {
                case 'day':
                    dateKey = moment(item.start).format('DD/MM');
                    break;
                case 'week':
                    dateKey = moment(item.start).startOf('isoWeek').format('WW/YYYY');
                    break;
                case 'month':
                    dateKey = moment(item.start).format('MM/YYYY');
                    break;
                default:
                    dateKey = moment(item.start).format('DD/MM/YYYY');
            }
            if (!groupedData[dateKey]) {
                groupedData[dateKey] = 0;
            }
            groupedData[dateKey] += item.total_time ? parseFloat(item.total_time) / 60 : 0; // Conversion en heures
        });

        const labels = Object.keys(groupedData);
        const durations = Object.values(groupedData);
        setChartData({ labels, durations });
    };

    // Format date and time
    const formatDateTime = (dateTime) => moment(dateTime).format('DD/MM/YYYY');
    const formatTime = (dateTime) => moment(dateTime).format('HH:mm');

    // Redirection vers la page profil
    const goToProfile = () => {
        router.push({
            pathname: '../PageProfil',
            params: { userId, userName },
        });
    };

    return (
        <ImageBackground
            source={require('../../assets/images/batground.png')}
            style={styles.backgroundImage}
            resizeMode="cover"
        >
            {/* LinearGradient couvrant toute la zone défilante */}
            <LinearGradient
                colors={['#00000080', '#00000080', '#3e3e3e']}
                style={styles.overlay}
            >
                <ScrollView
                    contentContainerStyle={styles.scrollContainer}
                    showsVerticalScrollIndicator={false}
                    horizontal={false}  // Assurer que le ScrollView global soit seulement en vertical
                    nestedScrollEnabled={true}  // Permet aux sous-ScrollView de fonctionner correctement
                >
                    {/* Icon de profil en haut à droite */}
                    <View style={styles.iconContainer} pointerEvents="box-none">
                        <Pressable onPress={goToProfile}>
                            <Icon name="person-circle-outline" size={40} color="#FDCB12" />
                        </Pressable>
                    </View>

                    <View style={styles.contentContainer}>
                        {/* Buttons for Day/Week/Month */}
                        <View style={styles.buttonContainer}>
                            <TouchableOpacity style={styles.button} onPress={() => processChartData(workingTimes, 'day')}>
                                <TextOrbitron style={styles.buttonText}>Day</TextOrbitron>
                            </TouchableOpacity>
                            <TouchableOpacity style={styles.button} onPress={() => processChartData(workingTimes, 'week')}>
                                <TextOrbitron style={styles.buttonText}>Week</TextOrbitron>
                            </TouchableOpacity>
                            <TouchableOpacity style={styles.button} onPress={() => processChartData(workingTimes, 'month')}>
                                <TextOrbitron style={styles.buttonText}>Month</TextOrbitron>
                            </TouchableOpacity>
                        </View>

                        {/* Scrollable Bar Chart uniquement en horizontal */}
                        <ScrollView
                            horizontal
                            showsHorizontalScrollIndicator={true}
                            style={styles.chartContainer}
                        >
                            <BarChart
                                data={{
                                    labels: chartData.labels && chartData.labels.length > 0 ? chartData.labels : [],
                                    datasets: [
                                        {
                                            data: chartData.durations && chartData.durations.length > 0 ? chartData.durations : [],
                                        },
                                    ],
                                }}
                                width={Math.max((chartData.labels && chartData.labels.length > 0 ? chartData.labels.length : 1) * 60, Dimensions.get('window').width * 0.9)}
                                height={220}
                                chartConfig={{
                                    backgroundColor: '#000',
                                    backgroundGradientFrom: '#000',
                                    backgroundGradientTo: '#3e3e3e',
                                    decimalPlaces: 0,
                                    color: (opacity = 1) => `rgba(253, 203, 18, ${opacity})`,
                                    labelColor: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
                                    style: {
                                        borderRadius: 16,
                                    },
                                    propsForDots: {
                                        r: '6',
                                        strokeWidth: '2',
                                        stroke: '#FDCB12',
                                    },
                                }}
                                style={styles.chart}
                            />
                        </ScrollView>

                        <TextOrbitronBold style={styles.userNameText}>
                            Your history, <TextOrbitronBold style={styles.highlight}>{userName}</TextOrbitronBold>
                        </TextOrbitronBold>

                        {loading ? (
                            <ActivityIndicator size="large" color="#E3B75B" />
                        ) : (
                            workingTimes.map((item) => (
                                <View key={item.id} style={styles.workingTimeItem}>
                                    <TextOrbitronBold style={styles.workingTimeDateText}>
                                        {formatDateTime(item.start)}
                                    </TextOrbitronBold>
                                    <TextOrbitron style={styles.workingTimeGroupText}>Groupe A</TextOrbitron>
                                    <TextOrbitron style={styles.workingTimeHourText}>
                                        {formatTime(item.start)} - {formatTime(item.end)}
                                    </TextOrbitron>
                                    <TextOrbitron style={styles.workingTimeHourText}>
                                        {item.total_time ? `${(item.total_time / 60).toFixed(2)} heures` : 'Non disponible'}
                                    </TextOrbitron>
                                </View>
                            ))
                        )}
                    </View>
                </ScrollView>
            </LinearGradient>
        </ImageBackground>
    );
}

const styles = StyleSheet.create({
    backgroundImage: {
        flex: 1,
        width: Dimensions.get('window').width,
        height: '100%',
    },
    scrollContainer: {
        paddingBottom: 100,
    },
    overlay: {
        flex: 1,
        justifyContent: 'flex-start',
        alignItems: 'center',
        padding: 20,
        width: '100%',
    },
    contentContainer: {
        paddingTop: 80,
        width: '100%',
        alignItems: 'center',
    },
    userNameText: {
        fontSize: 24,
        color: '#FDCB12',
        textAlign: 'center',
        marginBottom: 30,
    },
    highlight: {
        color: '#FDCB12',
    },
    buttonContainer: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        width: '100%',
        marginBottom: 20,
    },
    button: {
        backgroundColor: '#3e3e3e',
        padding: 10,
        borderRadius: 10,
        borderWidth: 1,
        borderColor: '#FDCB12',
    },
    buttonText: {
        color: '#FDCB12',
        fontSize: 16,
    },
    chartContainer: {
        backgroundColor: '#00000080',
        padding: 10,
        borderRadius: 16,
        marginVertical: 10,
    },
    chart: {
        borderRadius: 16,
    },
    workingTimeItem: {
        backgroundColor: 'rgba(255, 255, 255, 0.4)',
        padding: 25,
        marginVertical: 15,
        borderRadius: 15,
        borderWidth: 1,
        borderColor: 'rgba(255, 255, 255, 1)',
        width: '100%',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.1,
        shadowRadius: 10,
        elevation: 6,
        position: 'relative',
        overflow: 'hidden',
    },
    workingTimeDateText: {
        color: '#FDCB12',
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
    iconContainer: {
        position: 'absolute',
        top: 30,
        right: 20,
        zIndex: 10,
    },
});
