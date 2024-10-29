import { CameraView, CameraType, useCameraPermissions } from 'expo-camera';
import { useState, useEffect } from 'react';
import { Button, StyleSheet, Image, TextInput, Text, TouchableOpacity, View, ActivityIndicator } from 'react-native';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import Entypo from '@expo/vector-icons/Entypo';
import { useSession } from './ctx';
import { jwtDecode } from 'jwt-decode';
import { router } from 'expo-router';

export default function Camera() {
  const [facing, setFacing] = useState<CameraType>('back');
  const [torch, setTorch] = useState(false);
  const [spinnerVisible, setSpinnerVisible] = useState(false);
  const [isFetching, setIsFetching] = useState(false);
  const [expiredUrls, setExpiredUrls] = useState([]); // Stocker les URLs expirées
  const [code, setCode] = useState('');
  const [permission, requestPermission] = useCameraPermissions();
  const { session } = useSession();

  const userId = jwtDecode(session).sub;

  if (!permission) {
    return <View />;
  }

  if (!permission.granted) {
    return (
      <View style={styles.container}>
        <Text style={styles.message}>We need your permission to show the camera</Text>
        <Button onPress={requestPermission} title="grant permission" />
      </View>
    );
  }

  function toggleCameraFacing() {
    setFacing(current => (current === 'back' ? 'front' : 'back'));
  }

  function toggleFlash() {
    setTorch(!torch);
  }

  const onBarcodeScanned = (data) => {
    const transformDataRaw = data.raw.replace('localhost', '10.79.216.202');

    // Vérifie si l'URL a déjà été scannée et marquée comme expirée
    if (expiredUrls.includes(transformDataRaw)) {
      console.log("URL déjà expirée :", transformDataRaw);
      return; // Ne pas faire de requête pour cette URL
    }

    // Empêche les scans multiples pendant une requête
    if (isFetching) {
      return;
    }

    setIsFetching(true);

    console.log("transformDataRaw:", transformDataRaw);

    fetch(transformDataRaw, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    })
      .then(response => response.json())
      .then(data => {
        console.log("Success:", data);

        // Affiche l'alerte en fonction de la présence de data.time
        if (data.time) {
          alert(`${data.message}\nTime: ${data.time}`);
          router.push(`/?refreshQrCode=${new Date().getTime()}`); // Rafraîchir la page
        } else {
          alert(`${data.message}`);
        }

        // Marquer cette URL comme expirée
        setExpiredUrls(prev => [...prev, transformDataRaw]);

        // Vider les URLs expirées après 5 secondes
        setTimeout(() => {
          setExpiredUrls([]);
          console.log("Expired URLs list cleared");
        }, 5000); // 5000 ms = 5 secondes
      })
      .catch(error => {
        console.error("Error:", error);
      })
      .finally(() => {
        setSpinnerVisible(true); // Affiche le spinner
        setIsFetching(false); // Autoriser à nouveau les scans
      });
  };

  return (
    <View style={styles.container}>
      <CameraView
        style={styles.camera}
        facing={facing}
        enableTorch={torch}
        barcodeScannerSettings={{
          barcodeTypes: ["qr"],
        }}
        onBarcodeScanned={onBarcodeScanned}
      >
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={[styles.buttonLeft, styles.bounce]} onPress={toggleCameraFacing}>
            <MaterialCommunityIcons name="camera-flip-outline" size={44} color="white" />
          </TouchableOpacity>

          <View style={styles.centerContainer}>
            {isFetching ? (
              <ActivityIndicator size="large" color="yellow" />
            ) : (
              <>
                <View style={styles.qrCodeSlot}>
                  <Image source={require('../assets/images/qr-code.png')} style={styles.qrCodeImage} />
                </View>

                <TextInput
                  style={styles.codeInput}
                  value={code}
                  placeholder='456326'
                  placeholderTextColor="rgba(255, 255, 255, 0.7)"
                  onChangeText={setCode}
                />
              </>
            )}
          </View>

          <TouchableOpacity style={[styles.buttonRight, styles.bounce]} onPress={toggleFlash}>
            <Entypo name="flash" size={44} color={torch ? 'yellow' : 'white'} />
          </TouchableOpacity>
        </View>
      </CameraView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  message: {
    textAlign: 'center',
    paddingBottom: 10,
    color: 'white'
  },
  camera: {
    flex: 1,
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  qrCodeSlot: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    width: 230,
    height: 230,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 15,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 1)',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 10,
    },
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 10,
    marginBottom: 30,
  },
  qrCodeImage: {
    width: 200,
    height: 200,
  },
  codeInput: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    borderColor: 'rgba(255, 255, 255, 1)',
    borderWidth: 1,
    borderRadius: 10,
    paddingVertical: 10,
    paddingHorizontal: 20,
    textAlign: 'center',
    fontSize: 24,
    color: 'white',
    fontWeight: 'bold',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 6,
    },
    shadowOpacity: 0.2,
    shadowRadius: 10,
    elevation: 5,
    width: 275,
  },
  buttonContainer: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    backgroundColor: 'transparent',
    marginVertical: 64,
  },
  buttonLeft: {
    marginLeft: 20,
  },
  buttonRight: {
    marginRight: 20,
  },
  bounce: {
    animationDuration: '2s',
    animationName: 'bounce',
    animationIterationCount: 'infinite',
    animationTimingFunction: 'ease-in-out',
  },
  text: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
});
