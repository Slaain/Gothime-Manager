import axios from 'axios';

const API_URL = 'http://localhost:4000/api'; // Ajustez l'URL de votre API

export default {
  getAllOrganisations() {
    return axios.get(`${API_URL}/organisations`);
  },
  createOrganisation(organisationData) {
    return axios.post(`${API_URL}/organisations`, { organisation: organisationData });
  },
  getGroupsByOrganisation(organisationId) {
    return axios.get(`http://localhost:4000/api/organisations/${organisationId}`);
  },
};
