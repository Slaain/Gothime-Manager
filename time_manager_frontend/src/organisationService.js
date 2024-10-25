import axios from 'axios';

const API_URL = 'http://localhost:4000/api'; // Ajustez l'URL de votre API

export default {
  getAllOrganisations() {
    return axios.get(`${API_URL}/organisations`,
      {},
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
    );
  },
  createOrganisation(organisationData) {
    return axios.post(`${API_URL}/organisations`, { organisation: organisationData },
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
    );
  },
  getGroupsByOrganisation(organisationId) {
    return axios.get(`http://localhost:4000/api/organisations/${organisationId}`,
      {},
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
    );
  },
};
