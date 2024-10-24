import React, { useEffect, useState } from 'react';
import { StyleSheet, Text as DefaultText, View, ActivityIndicator, ImageBackground, Dimensions, ScrollView, Pressable, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { BarChart } from 'react-native-chart-kit';
import { useLocalSearchParams, useRouter } from 'expo-router';
import moment from 'moment';
import Icon from 'react-native-vector-icons/Ionicons'; // Import Icon
import { useSession } from "@/components/ctx";
import { jwtDecode } from 'jwt-decode';
// Custom Text component with Orbitron font
const TextOrbitron = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'Orbitron' }]} />;
const TextOrbitronBold = (props) => <DefaultText {...props} style={[props.style, { fontFamily: 'OrbitronBold' }]} />;

export default function GothamNeedsYouScreen() {

    const { userName } = useLocalSearchParams();
    const [workingTimes, setWorkingTimes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [chartData, setChartData] = useState([]);
    const [viewMode, setViewMode] = useState('daily'); // Default to 'daily'
    const router = useRouter(); // Utilisation de router pour redirection
    const { session } = useSession();
    const userId = jwtDecode(session).sub;
    const [loadingChart, setLoadingChart] = useState(true);

    const colors = {
        primary: "#FDCB12"
    }

    const fetchDataForViewMode = async (mode) => {
        let url = '';

        switch (mode) {
            case 'daily':
                url = `http://10.79.216.9:4000/api/workingtimes/daily/${userId}`;
                break;
            case 'weekly':
                url = `http://10.79.216.9:4000/api/workingtimes/weekly/${userId}`;
                break;
            case 'monthly':
                url = `http://10.79.216.9:4000/api/workingtimes/monthly/${userId}`;
                break;
            default:
                return;
        }

        try {
            setLoadingChart(true);
            setLoading(true);
            const response = await axios.get(url);

            console.log("response.data.data : ", response.data);

            setWorkingTimes(response.data);
            setLoadingChart(false);
            setLoading(false);
            processChartData(response.data, mode);
        } catch (error) {
            console.error(`Error fetching ${mode} working times:`, error.response?.data || error.message);
            setLoadingChart(false);
            setLoading(false);
        }
    };

    // Fetch working times
    const getWorkingTimes = async () => {
        try {
            if (!userId) {
                console.error("Error: userId is undefined or null");
                setLoading(false);
                return;
            }
            const response = await axios.get(`http://10.79.216.9:4000/api/workingtimes/${userId}`);
            setWorkingTimes(response.data.data);
            setLoading(false);
            processChartData(response.data.data, 'day'); // Process initial data
        } catch (error) {
            console.error('Error fetching working times:', error.response?.data || error.message);
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchDataForViewMode(viewMode);
    }, [viewMode]);

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
        console.log("Icon Pressed");  // Si ça n'apparaît pas, le problème est ailleurs
        router.push({
            pathname: '/profil',
            params: { userId, userName },
        });
    };

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
                    {loading && <ActivityIndicator size="large" color="#FDCB12" />}
                    {!loading &&
                        <>

                            <View style={styles.iconContainer} pointerEvents="box-none">
                                <Pressable onPress={goToProfile}>
                                    <Icon name="person-circle-outline" size={40} color="#FDCB12" />
                                </Pressable>
                            </View>

                            <View style={styles.contentContainer}>
                                {/* Buttons for Day/Week/Month */}
                                <View style={styles.buttonContainer}>
                                    <TouchableOpacity style={[viewMode === 'daily' ? { backgroundColor: colors.primary } : { backgroundColor: '#3e3e3e' }, styles.button]} onPress={() => setViewMode('daily')}>
                                        <TextOrbitron style={[viewMode === 'daily' ? { color: "white" } : { color: colors.primary }, styles.buttonText]}>Day</TextOrbitron>
                                    </TouchableOpacity>
                                    <TouchableOpacity style={[viewMode === 'weekly' ? { backgroundColor: colors.primary } : { backgroundColor: '#3e3e3e' }, styles.button]} onPress={() => setViewMode('weekly')}>
                                        <TextOrbitron style={[viewMode === 'weekly' ? { color: "white" } : { color: colors.primary }, styles.buttonText]}>Week</TextOrbitron>
                                    </TouchableOpacity>
                                    <TouchableOpacity style={[viewMode === 'monthly' ? { backgroundColor: colors.primary } : { backgroundColor: '#3e3e3e' }, styles.button]} onPress={() => setViewMode('monthly')}>
                                        <TextOrbitron style={[viewMode === 'monthly' ? { color: "white" } : { color: colors.primary }, styles.buttonText]}>Month</TextOrbitron>
                                    </TouchableOpacity>
                                </View>

                                <BarChart
                                    data={{
                                        labels: chartData.labels || [],
                                        datasets: [
                                            {
                                                data: chartData.durations || [],
                                            },
                                        ],
                                    }}
                                    width={Dimensions.get('window').width * 0.9} // from react-native
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

                                <TextOrbitronBold style={styles.userNameText}>
                                    Your history, <TextOrbitronBold style={styles.highlight}>{userName}</TextOrbitronBold>
                                </TextOrbitronBold>

                                {loading ? (
                                    <ActivityIndicator size="large" color="#E3B75B" />
                                ) : (
                                    workingTimes
                                        .sort((a, b) => new Date(a.start) - new Date(b.start))
                                        .map((item) => (
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
                        </>
                    }
                </LinearGradient>
            </ScrollView>
        </ImageBackground >
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
        minHeight: Dimensions.get('window').height,
    },
    overlay: {
        flex: 1,
        justifyContent: 'flex-start',
        alignItems: 'center',
        padding: 20,
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
        // backgroundColor: '#3e3e3e',
        padding: 10,
        borderRadius: 10,
        borderWidth: 1,
        borderColor: '#FDCB12',
    },
    buttonText: {
        // color: '#FDCB12',
        fontSize: 16,
    },
    chart: {
        marginVertical: 10,
        borderRadius: 16,
    },
    workingTimeItem: {
        backgroundColor: 'rgba(255, 255, 255, 0.4)',
        padding: 25,
        marginVertical: 15,
        borderRadius: 15,
        borderWidth: 1,
        borderColor: 'rgba(255, 255, 255, 1)',
        width: Dimensions.get('window').width * 0.9,
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
        top: 50,
        right: 20,
        zIndex: 10,  // Augmenter le z-index pour s'assurer que l'icône est au-dessus des autres éléments
    },
});
