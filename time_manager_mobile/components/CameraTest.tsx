import { CameraView, CameraType, useCameraPermissions } from 'expo-camera';
import { useState, useRef, useEffect } from 'react';
import { Button, StyleSheet, Text, TouchableOpacity, View, Image, TextInput } from 'react-native';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import Entypo from '@expo/vector-icons/Entypo';

export default function Camera() {
  const [facing, setFacing] = useState<CameraType>('back');
  const [torch, setTorch] = useState(false);
  const [code, setCode] = useState('');
  const [permission, requestPermission] = useCameraPermissions();

  const [qrSlotDimensions, setQrSlotDimensions] = useState(null); // Stocker les dimensions du QR code slot
  const qrCodeSlotRef = useRef(null); // Référence à l'élément QR Code Slot

  // Obtenir les dimensions de qrCodeSlot après le rendu
  useEffect(() => {
    if (qrCodeSlotRef.current) {
      // Mesurer les dimensions de l'élément après le rendu
      qrCodeSlotRef.current.measure((x, y, width, height, pageX, pageY) => {

        console.log({
          left: pageX,
          top: pageY,
          right: pageX + width,
          bottom: pageY + height,
        });

        setQrSlotDimensions({
          left: pageX,
          top: pageY,
          right: pageX + width,
          bottom: pageY + height,
        });
      });

      console.log("qrCodeSlotRef.current", qrCodeSlotRef.current);


    }
  }, [qrCodeSlotRef]);

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

  // Vérifier si le QR code est dans la zone
  const isInsideQrCodeSlot = (boundingBox) => {
    if (!qrSlotDimensions) return false; // S'assurer que nous avons les dimensions du slot

    const { origin, size } = boundingBox;
    const qrLeft = origin.x;
    const qrRight = origin.x + size.width;
    const qrTop = origin.y;
    const qrBottom = origin.y + size.height;
    console.log({
      leftQR: qrSlotDimensions.left,
      rightQR: qrSlotDimensions.right,
      topQR: qrSlotDimensions.top,
      bottomQR: qrSlotDimensions.bottom,
    });


    // Vérifier que le QR code est entièrement à l'intérieur du slot
    const isInHorizontalBounds = qrLeft >= qrSlotDimensions.left && qrRight <= qrSlotDimensions.right;
    const isInVerticalBounds = qrTop >= qrSlotDimensions.top && qrBottom <= qrSlotDimensions.bottom;

    return isInHorizontalBounds && isInVerticalBounds;
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
        onBarcodeScanned={(data) => {
          console.log(data.boundingBox);
          console.log({
            leftQR: qrSlotDimensions.left,
            rightQR: qrSlotDimensions.right,
            topQR: qrSlotDimensions.top,
            bottomQR: qrSlotDimensions.bottom,
          });
          if (isInsideQrCodeSlot(data.boundingBox)) {
            console.log("QR code scanné :", data.raw);  // Gérer le scan ici
          } else {
            console.log("QR code hors de la zone");
          }
        }}
      >
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.buttonLeft} onPress={toggleCameraFacing}>
            <MaterialCommunityIcons name="camera-flip-outline" size={44} color="white" />
          </TouchableOpacity>

          <View style={{ flex: 1 }} >
            <View style={styles.qrCodeSlot} ref={qrCodeSlotRef}>
              <Image source={require('../assets/images/qr-code.png')} style={{ width: 230, height: 230 }} />
            </View>

            <TextInput
              style={styles.codeInput}
              value={code}
              placeholder='456326'
              placeholderTextColor="rgba(255, 255, 255, 0.7)"
              onChangeText={setCode}
            />
          </View>

          <TouchableOpacity style={styles.buttonRight} onPress={toggleFlash}>
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
  qrCodeSlot: {
    position: 'absolute',
    flex: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.4)', // Couleur blanche avec transparence
    width: 275,
    height: 275,
    justifyContent: 'center',
    alignItems: 'center',
    left: '50%',
    top: '50%',
    transform: [{ translateX: -137.5 }, { translateY: -180 }],
    borderRadius: 15,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 1)', // Bordure blanche semi-transparente
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 10,
    },
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 10,
  },
  codeInput: {
    backgroundColor: 'rgba(255, 255, 255, 0.4)',
    borderColor: 'rgba(255, 255, 255, 1)',
    borderWidth: 1,
    borderRadius: 10,
    paddingVertical: 10,
    paddingHorizontal: 20,
    marginTop: 30,
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
    position: 'absolute',
    left: '50%',
    transform: [{ translateX: -137.5 }],
    bottom: 150,
    width: 275
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
  text: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
});
