<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center w-full h-full bg-black bg-opacity-50 modal">
    <div class="w-2/3 p-6 bg-white rounded-lg">
      <div class="flex items-center justify-between mb-4">
        <h2 class="text-2xl font-bold">Organisation's Users</h2>

        <div class="flex items-center space-x-2">
          <button
            @click="toggleAddUser"
            class="relative flex items-center p-2 space-x-1 transition-all duration-300 ease-in-out"
          >
            <span v-if="!showEmailInput">+</span>
          </button>

          <button
            @click="$emit('close-modal')"
            class="text-gray-500 hover:text-gray-700"
          >
            X
          </button>
        </div>
      </div>

      <div
        class="relative flex items-center overflow-hidden transition-all duration-500 ease-in-out"
        :style="showEmailInput ? 'max-width: 300px;' : 'max-width: 0px;'"
      >
        <input
          v-show="showEmailInput"
          v-model="searchEmail"
          placeholder="Enter email to add user"
          class="border rounded-lg p-2 w-[250px] transition-all duration-500 ease-in-out"
        />
        <button
          v-if="showEmailInput"
          @click="addUserToOrganisation"
          class="p-2 ml-2 text-white bg-blue-500 rounded-lg"
        >
          Add
        </button>
      </div>

      <table class="w-full mt-4 table-auto">
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
          <tr v-for="user in displayedUsers" :key="user.id" class="border-b">
            <td class="p-2">{{ user.username }}</td>
            <td class="p-2">{{ user.email }}</td>
            <td class="p-4 border-b border-slate-200">
              <div v-if="user.role_id === 1">Admin</div>
              <select
                v-else
                v-model="user.role_id"
                @change="updateUserRole(user)"
                class="w-[120px]"
              >
                <option value="2">Manager</option>
                <option value="3">Employee</option>
              </select>
            </td>
            <td class="p-2">
              <label class="switch">
                <input
                  type="checkbox"
                  v-model="user.clock.status"
                  @change="handleClockToggle(user)"
                />
                <span class="slider round"></span>
              </label>
            </td>
            <td class="p-2">
              <button
                @click="openEditModal(user)"
                class="text-blue-600 hover:underline"
              >
                Edit
              </button>
            </td>
            <td class="p-2">
              <button
                @click="deleteUser(user.id)"
                class="text-red-600 hover:underline"
              >
                Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination -->
      <div class="flex items-center justify-between mt-4">
        <div class="text-sm text-gray-500">
          Showing {{ startIndex + 1 }} to {{ endIndex }} of {{ totalUsers }} users
        </div>
        <div class="flex gap-2">
          <button
            @click="handlePageChange(currentPage - 1)"
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded disabled:opacity-50 disabled:cursor-not-allowed"
            :class="currentPage === 1 ? 'bg-gray-200' : 'bg-blue-500 text-white hover:bg-blue-600'"
          >
            Previous
          </button>
          
          <div class="flex gap-1">
            <button
              v-for="pageNumber in displayedPages"
              :key="pageNumber"
              @click="handlePageChange(pageNumber)"
              class="px-3 py-1 rounded"
              :class="pageNumber === currentPage ? 'bg-blue-500 text-white' : 'bg-gray-200 hover:bg-gray-300'"
            >
              {{ pageNumber }}
            </button>
          </div>

          <button
            @click="handlePageChange(currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded disabled:opacity-50 disabled:cursor-not-allowed"
            :class="currentPage === totalPages ? 'bg-gray-200' : 'bg-blue-500 text-white hover:bg-blue-600'"
          >
            Next
          </button>
        </div>
      </div>

      <edit-user-modal
        v-if="showEditModal"
        :user="selectedUser"
        @close="closeEditModal"
        @save="fetchUsers"
      />
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";
import EditUserModal from "./EditUserModal.vue";

export default {
  components: {
    EditUserModal,
  },
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
      showEmailInput: false,
      searchEmail: "",
      showEditModal: false,
      selectedUser: null,
      currentPage: 1,
      itemsPerPage: 6,
    };
  },
  computed: {
    sortedUsers() {
      return [...this.users].sort((a, b) => a.role_id - b.role_id);
    },
    totalUsers() {
      return this.sortedUsers.length;
    },
    totalPages() {
      return Math.ceil(this.totalUsers / this.itemsPerPage);
    },
    startIndex() {
      return (this.currentPage - 1) * this.itemsPerPage;
    },
    endIndex() {
      return Math.min(this.startIndex + this.itemsPerPage, this.totalUsers);
    },
    displayedUsers() {
      return this.sortedUsers.slice(this.startIndex, this.endIndex);
    },
    displayedPages() {
      const pages = [];
      const maxVisiblePages = 5;
      const halfVisible = Math.floor(maxVisiblePages / 2);
      
      let startPage = Math.max(1, this.currentPage - halfVisible);
      let endPage = Math.min(this.totalPages, startPage + maxVisiblePages - 1);
      
      if (endPage - startPage + 1 < maxVisiblePages) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
      }
      
      for (let i = startPage; i <= endPage; i++) {
        pages.push(i);
      }
      
      return pages;
    }
  },
  mounted() {
    this.fetchUsers();
  },
  methods: {
    handlePageChange(newPage) {
      if (newPage >= 1 && newPage <= this.totalPages) {
        this.currentPage = newPage;
      }
    },
    openEditModal(user) {
      this.selectedUser = { ...user };
      this.showEditModal = true;
    },
    closeEditModal() {
      this.selectedUser = null;
      this.showEditModal = false;
    },
    async deleteUser(userId) {
      try {
        await axios.delete(
          `http://localhost:4000/api/organisations/${this.organisationId}/users/${userId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.showSuccessToast("Utilisateur supprimé avec succès !");
        await this.fetchUsers();
        
        if (this.displayedUsers.length === 0 && this.currentPage > 1) {
          this.currentPage--;
        }
      } catch (error) {
        console.error("Erreur lors de la suppression de l'utilisateur:", error);
        this.showErrorToast("Échec de la suppression de l'utilisateur.");
      }
    },
    async addUserToOrganisation() {
      try {
        await axios.post(
          `http://localhost:4000/api/organisations/${this.organisationId}/users`,
          {
            email: this.searchEmail,
          },
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
              "Content-Type": "application/json",
            },
          }
        );

        await this.fetchUsers();
        this.currentPage = this.totalPages; // Aller à la dernière page
        this.showSuccessToast("Utilisateur ajouté avec succès !");
        this.searchEmail = "";
        this.showEmailInput = false;
      } catch (error) {
        console.error("Erreur lors de l'ajout de l'utilisateur à l'organisation:", error);
        this.showErrorToast(error.response.data.error);
      }
    },
    toggleAddUser() {
      this.showEmailInput = !this.showEmailInput;
    },
    async fetchUsers() {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/organisations/${this.organisationId}/users`
        );
        this.users = response.data.users;
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs:", error);
      }
    },
    async updateUserRole(user) {
      if (user.role_id === 1) {
        this.showErrorToast("Le rôle d'un administrateur ne peut pas être modifié.");
        return;
      }

      try {
        await axios.put(
          `http://localhost:4000/api/organisations/${this.organisationId}/users/${user.id}/${user.role_id}`
        );
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
        await this.fetchUsers();
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