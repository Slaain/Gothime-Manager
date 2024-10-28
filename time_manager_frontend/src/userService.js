import axios from 'axios';

const API_URL = 'http://localhost:4000/api/users';
const CLOCK_API_URL = 'http://localhost:4000/api/clocks';
const REGISTER_API_URL =  'http://localhost:4000/api/register';
const ORGANISATION_API_URL = 'http://localhost:4000/api/organisations';

export default {
  createUser(user) {
    console.log('Création de l\'utilisateur:', user);
    return axios.post(REGISTER_API_URL, user,
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      }
    }
    )
      .then(response => response.data);
  },

  updateUser(userID, user) {
    return axios.put(`${API_URL}/${userID}`, user,
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      }
    }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la mise à jour de l\'utilisateur:', error);
        throw error;
      });
  },

  getUser(userID) {
    return axios.get(`${API_URL}/${userID}`,
      {},
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la récupération de l\'utilisateur:', error);
        throw error;
      });
  },

  deleteUser(userID) {
    console.log("Suppression de l'utilisateur");
    console.log(`Bearer ${localStorage.getItem("authToken")}`);
    
    
    return axios.delete(`${API_URL}/${userID}`, 
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la suppression de l\'utilisateur:', error);
        throw error;
      });
  },

  getUsers(limit, offset) {
    return axios.get(`${API_URL}?limit=${limit}&offset=${offset}`,
      {},
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la récupération des utilisateurs:', error);
        throw error;
      });
  },

  // New method for clock-in/clock-out
  toggleClock(userID) {
    // Juste faire une requête PUT avec l'ID de l'utilisateur
    console.log("request toggle url : ", `${CLOCK_API_URL}/admin/${userID}`);
    
    return axios.post(`${CLOCK_API_URL}/admin/${userID}`,
      {},
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors du basculement de l\'horloge:', error);
        throw error;
      });
  },
  checkIfUserIsWorking(userID) {
    
    return axios.get(`${CLOCK_API_URL}/is_working/admin/${userID}`,

      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .then(data => {
        console.log("Data:", data);
        return data.is_working;
      }
    )

      .catch(error => {
        console.error('Erreur lors de la vérification si l\'utilisateur travaille:', error);
        throw error;
      });
  }
  ,


  getOrganisations() {
    return axios.get(ORGANISATION_API_URL,
      {},
      {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      }
    )
      .then(response => response.data)
      .catch(error => {
        console.error('Erreur lors de la récupération des organisations:', error);
        throw error;
      });
  },

  getUsersByOrganisationAndGroups(organisationId, limit, offset) {
    // Construire les paramètres de requête de manière dynamique
    const queryParams = new URLSearchParams();
    if (limit) queryParams.append("limit", limit);
    if (offset) queryParams.append("offset", offset);
  
    const url = `${ORGANISATION_API_URL}/${organisationId}/users_with_groups${queryParams.toString() ? `?${queryParams.toString()}` : ''}`;
  
    console.log("URL de requête:", url);
  
    return axios
      .get(url, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      })
      .then((response) => {
        console.log("API Response:", response.data);
        if (response.data && response.data.users) {
          return response.data;
        } else {
          throw new Error("Invalid response structure");
        }
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération des employés avec groupes:", error);
        throw error;
      });
  }
  
  
};
