<template>
  <div class="modal fixed inset-0 z-50 flex items-center justify-center w-full h-full bg-black bg-opacity-50">
    <div class="bg-white rounded-lg p-6 w-2/3">
      <div class="flex justify-between items-center mb-4">
        <h2 class="text-2xl font-bold">Organisation's Users</h2>
        <button @click="$emit('close-modal')" class="text-gray-500 hover:text-gray-700">X</button>
      </div>

      <table class="w-full table-auto">
        <thead>
          <tr class="bg-gray-200">
            <th class="p-2">Member Name</th>
            <th class="p-2">Email</th>
            <th class="p-2">Role</th>
            <th class="p-2">Status</th>
            <th class="p-2"></th>
            <th class="p-2"></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in sortedUsers" :key="user.id" class="border-b">
            <td class="p-2">{{ user.username }}</td>
            <td class="p-2">{{ user.email }}</td>
            <td class="p-4 border-b border-slate-200">
              <!-- Afficher "Admin" en lecture seule si le rôle est Admin -->
              <div v-if="user.role_id === 1">Admin</div>
              <!-- Sinon, afficher le select pour Manager et Employee -->
              <select v-else v-model="user.role_id" @change="updateUserRole(user)" class="w-[120px]">
                <option value="2">Manager</option>
                <option value="3">Employee</option>
              </select>
            </td>

            <!-- Toggle button for Clock In/Out -->
            <td class="p-2">
              <label class="switch">
                <input type="checkbox" v-model="user.clock.status" @change="handleClockToggle(user)">
                <span class="slider round"></span>
              </label>
            </td>
            <td class="p-2">
              <button class="text-blue-600 hover:underline">Edit</button>
            </td>
            <td class="p-2">
              <button class="text-red-600 hover:underline">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
  props: {
    organisationId: {
      type: Number,
      required: true,
    },
  },
  setup() {
    const toast = useToast();
    return { toast };
  },
  data() {
    return {
      users: [],
    };
  },
  mounted() {
    this.fetchUsers();
  },
  computed: {
    // Trier les utilisateurs : Admin (1), Manager (2), Employee (3)
    sortedUsers() {
      return this.users.slice().sort((a, b) => a.role_id - b.role_id);
    },
  },
  methods: {
    async fetchUsers() {
      try {
        const response = await axios.get(`http://localhost:4000/api/organisations/${this.organisationId}/users`);
        this.users = response.data.users; // Assign the fetched users to the component data
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs:", error);
      }
    },

    // Méthode pour gérer le changement de rôle
    async updateUserRole(user) {
      if (user.role_id === 1) {
        this.showErrorToast("Le rôle d'un administrateur ne peut pas être modifié.");
        return;
      }

      try {
        await axios.put(`http://localhost:4000/api/organisations/${this.organisationId}/users/${user.id}`, {
          role_id: user.role_id,
        });
        this.showSuccessToast("Role mis à jour avec succès !");
      } catch (error) {
        console.error("Erreur lors de la mise à jour du rôle:", error);
        this.showErrorToast("Échec de la mise à jour du rôle.");
      }
    },

    async handleClockToggle(user) {
      try {
        await axios.post(`http://localhost:4000/api/clocks/${user.id}`, {
          status: user.clock.status ? "clock_in" : "clock_out",
        });
        this.fetchUsers();
        this.showSuccessToast("Clock action successful!");
      } catch (error) {
        console.error("Erreur lors de la mise à jour du statut de la clock:", error);
        this.showErrorToast("Failed to toggle clock.");
      }
    },

    showSuccessToast(message = "Successful operation") {
      this.toast.success(message);
    },

    showErrorToast(message = "An error occurred") {
      this.toast.error(message);
    },
  },
};
</script>

<style scoped>
.modal {
  z-index: 9999;
}

.table-auto {
  width: 100%;
  border-collapse: collapse;
}

table {
  width: 100%;
}

th,
td {
  padding: 8px 12px;
  text-align: left;
}

thead th {
  background-color: #f1f1f1;
}

tbody tr {
  border-bottom: 1px solid #ddd;
}

.switch {
  position: relative;
  display: inline-block;
  width: 34px;
  height: 20px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: 0.4s;
  border-radius: 34px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 16px;
  width: 16px;
  left: 2px;
  bottom: 2px;
  background-color: white;
  transition: 0.4s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #4caf50;
}

input:checked + .slider:before {
  transform: translateX(14px);
}
</style>
