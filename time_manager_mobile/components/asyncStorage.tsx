import AsyncStorage from '@react-native-async-storage/async-storage';

export const storeToken = async (token: string) => {
    try {
        await AsyncStorage.setItem('userToken', token);
    } catch (error) {
        console.error('Error storing token', error);
    }
};

export const getToken = async () => {
    try {
        const token = await AsyncStorage.getItem('userToken');
        return token;
    } catch (error) {
        console.error('Error retrieving token', error);
        return null;
    }
};

export const removeToken = async () => {
    try {
        await AsyncStorage.removeItem('userToken');
    } catch (error) {
        console.error('Error removing token', error);
    }
};