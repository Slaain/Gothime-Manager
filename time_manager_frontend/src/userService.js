import axios from 'axios';

const API_URL = 'http://localhost:4000/api/users';
const CLOCK_API_URL = 'http://localhost:4000/api/clocks'; // Assuming clocks are managed separately

export default {
  // Existing user methods
  createUser(user) {
    return axios.post(API_URL, user)
      .then(response => response.data);
  },

  updateUser(userID, user) {
    return axios.put(`${API_URL}/${userID}`, user)
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la mise à jour de l\'utilisateur:', error);
        throw error;
      });
  },

  getUser(userID) {
    return axios.get(`${API_URL}/${userID}`)
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la récupération de l\'utilisateur:', error);
        throw error;
      });
  },

  deleteUser(userID) {
    return axios.delete(`${API_URL}/${userID}`)
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la suppression de l\'utilisateur:', error);
        throw error;
      });
  },

  getUsers(limit, offset) {
    return axios.get(`${API_URL}?limit=${limit}&offset=${offset}`)
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la récupération des utilisateurs:', error);
        throw error;
      });
  },

  // New method for clock-in/clock-out
  toggleClock(userID) {
    // Juste faire une requête PUT avec l'ID de l'utilisateur
    return axios.post(`${CLOCK_API_URL}/${userID}`)
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors du basculement de l\'horloge:', error);
        throw error;
      });
  },
  
};
