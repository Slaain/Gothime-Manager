import React, { useEffect, useState } from 'react';
import { StyleSheet, Text as DefaultText, View, ActivityIndicator, ImageBackground, Dimensions, ScrollView, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import axios from 'axios';
import { BarChart } from 'react-native-chart-kit';
import { useLocalSearchParams, useRouter } from 'expo-router';
import moment from 'moment';
import Icon from 'react-native-vector-icons/Ionicons';
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
  const router = useRouter();
  const { session } = useSession();
  const userId = jwtDecode(session).sub;

  // Function to fetch data based on the view mode
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
      setLoading(true);
      const response = await axios.get(url);
      setWorkingTimes(response.data.data);
      setLoading(false);
      processChartData(response.data.data, mode);
    } catch (error) {
      console.error(`Error fetching ${mode} working times:`, error.response?.data || error.message);
      setLoading(false);
    }
  };

  useEffect(() => {
    // Fetch data whenever viewMode changes
    fetchDataForViewMode(viewMode);
  }, [viewMode]);

  // Process chart data depending on view mode
  const processChartData = (data, mode) => {
    let groupedData = {};
    data.forEach(item => {
      let dateKey;
      switch (mode) {
        case 'daily':
          dateKey = moment(item.start).format('DD/MM');
          break;
        case 'weekly':
          dateKey = moment(item.start).startOf('isoWeek').format('WW/YYYY');
          break;
        case 'monthly':
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
          {!loading && (
            <>
              <View style={styles.iconContainer} pointerEvents="box-none">
                <TouchableOpacity onPress={goToProfile}>
                  <Icon name="person-circle-outline" size={40} color="#FDCB12" />
                </TouchableOpacity>
              </View>

              <View style={styles.contentContainer}>
                {/* Buttons for Daily/Weekly/Monthly */}
                <View style={styles.buttonContainer}>
                  <TouchableOpacity style={styles.button} onPress={() => setViewMode('daily')}>
                    <TextOrbitron style={styles.buttonText}>Daily</TextOrbitron>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.button} onPress={() => setViewMode('weekly')}>
                    <TextOrbitron style={styles.buttonText}>Weekly</TextOrbitron>
                  </TouchableOpacity>
                  <TouchableOpacity style={styles.button} onPress={() => setViewMode('monthly')}>
                    <TextOrbitron style={styles.buttonText}>Monthly</TextOrbitron>
                  </TouchableOpacity>
                </View>

                {/* Bar Chart */}
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
                  }}
                  style={styles.chart}
                />

                <TextOrbitronBold style={styles.userNameText}>
                  Your history, <TextOrbitronBold style={styles.highlight}>{userName}</TextOrbitronBold>
                </TextOrbitronBold>

                {workingTimes
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
                  ))}
              </View>
            </>
          )}
        </LinearGradient>
      </ScrollView>
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
    zIndex: 10,
  },
});
