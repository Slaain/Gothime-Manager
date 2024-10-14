// src/userService.js
import axios from 'axios';

const API_URL = 'http://localhost:4000/api/users';

export default {
  createUser(user) {
    return axios.post(API_URL, user)
      .then(response => response.data)
      // .catch(error => {
      //   console.error('Erreur lors de la création de l\'utilisateur:', error);
      //   throw error;
      // });
  },

  updateUser(userID, user) {
    return axios.put(`${API_URL}/${userID}`, { user })
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
};
