import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

const storage = {
  getItem: (name) => AsyncStorage.getItem(name).then(value => (value ? JSON.parse(value) : null)),
  setItem: (name, value) => AsyncStorage.setItem(name, JSON.stringify(value)),
  removeItem: (name) => AsyncStorage.removeItem(name),
};

const useUserStatsStore = create(
  persist(
    (set) => ({
      
      username: '', // Nom d'utilisateur
      email: '',    // Adresse e-mail

      // Fonction pour définir le nom d'utilisateur
      setUsername: (username) => set({ username }),

      // Fonction pour définir l'adresse e-mail
      setEmail: (email) => set({ email }),

      

      // Fonction pour réinitialiser les données (calories et poids)
      resetStats: () => set({ username: '', email: '' }),
    }),
    {
      name: 'user-stats-storage',
      storage, // Utilisation de AsyncStorage pour persister les données
    }
  )
);

export default useUserStatsStore;
