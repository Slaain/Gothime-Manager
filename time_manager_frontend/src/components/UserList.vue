<template>
  <div class="max-w-[720px] mx-auto">
    <div
      class="relative flex flex-col w-full h-full bg-white shadow-md text-slate-700 rounded-xl bg-clip-border"
    >
      <div
        class="relative mx-4 mt-4 overflow-hidden bg-white rounded-none text-slate-700 bg-clip-border"
      >
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-slate-800">Employees List</h3>
            <p class="text-slate-500">Review each person before edit</p>
          </div>
          <div class="flex flex-col gap-2 shrink-0 sm:flex-row">
            <button
              @click="openUserModal"
              class="flex select-none items-center gap-2 rounded bg-slate-800 py-2.5 px-4 text-xs font-semibold text-white shadow-md shadow-slate-900/10 transition-all hover:shadow-lg hover:shadow-slate-900/20 focus:opacity-[0.85] focus:shadow-none active:opacity-[0.85] active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
              type="button"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="currentColor"
                aria-hidden="true"
                stroke-width="2"
                class="w-4 h-4"
              >
                <path
                  d="M6.25 6.375a4.125 4.125 0 118.25 0 4.125 4.125 0 01-8.25 0zM3.25 19.125a7.125 7.125 0 0114.25 0v.003l-.001.119a.75.75 0 01-.363.63 13.067 13.067 0 01-6.761 1.873c-2.472 0-4.786-.684-6.76-1.873a.75.75 0 01-.364-.63l-.001-.122zM19.75 7.5a.75.75 0 00-1.5 0v2.25H16a.75.75 0 000 1.5h2.25v2.25a.75.75 0 001.5 0v-2.25H22a.75.75 0 000-1.5h-2.25V7.5z"
                ></path>
              </svg>
              Add member
            </button>
          </div>
        </div>
      </div>

      <div
        v-if="showCreateUserModal"
        id="default-modal"
        tabindex="-1"
        aria-hidden="true"
        class="fixed inset-0 z-50 flex items-center justify-center w-full h-full overflow-y-auto bg-gray-800 bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white">
          <p class="text-xl font-extrabold text-zinc-950">New User</p>
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
            User's Name
            <p
              class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500"
            >
              (30 characters maximum)
            </p>
          </label>
          <input
            v-model="newUser.username"
            placeholder="Please enter your full name"
            class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            type="text"
          />
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
            >User's Email</label
          >
          <input
            v-model="newUser.email"
            placeholder="Please enter your email"
            class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            type="text"
          />
          <p class="h-6 text-red-600">{{ error }}</p>
          <button
            @click="createUser"
            class="w-full py-2 mt-4 text-white transition-all bg-blue-500 rounded-lg hover:bg-blue-600"
          >
            Create User
          </button>
          <button
            @click="closeUserModal"
            class="w-full py-2 mt-2 text-white transition-all bg-red-500 rounded-lg hover:bg-red-600"
          >
            Cancel
          </button>
        </div>
      </div>

      <div
        v-if="showUpdateUserModal"
        id="default-modal"
        tabindex="-1"
        aria-hidden="true"
        class="fixed inset-0 z-50 flex items-center justify-center w-full h-full overflow-y-auto bg-gray-800 bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white">
          <p class="text-xl font-extrabold text-zinc-950">Update User</p>
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
            User's Name
            <p
              class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500"
            >
              (30 characters maximum)
            </p>
          </label>
          <input
            v-model="newUser.username"
            placeholder="Please enter your full name"
            class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            type="text"
          />
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
            >User's Email</label
          >
          <input
            v-model="newUser.email"
            placeholder="Please enter your email"
            class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            type="text"
          />
          <p class="h-6 text-red-600">{{ error }}</p>
          <button
            @click="updateUser"
            class="w-full py-2 mt-4 text-white transition-all bg-blue-500 rounded-lg hover:bg-blue-600"
          >
            Update
          </button>
          <button
            @click="closeUpdateUserModal"
            class="w-full py-2 mt-2 text-white transition-all bg-red-500 rounded-lg hover:bg-red-600"
          >
            Cancel
          </button>
        </div>
      </div>

      <div
        v-if="showDeleteUserModal"
        id="default-modal"
        tabindex="-1"
        aria-hidden="true"
        class="fixed inset-0 z-50 flex items-center justify-center w-full h-full overflow-y-auto bg-gray-800 bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white">
          <p class="text-xl font-extrabold text-zinc-950">Delete User</p>
          <p>Are you sure you want to delete this user?</p>
          <p class="h-6 text-red-600">{{ error }}</p>
          <button
            @click="deleteEmployee"
            class="w-full py-2 mt-4 text-white transition-all bg-blue-500 rounded-lg hover:bg-blue-600"
          >
            Delete
          </button>
          <button
            @click="closeUserDeleteModal"
            class="w-full py-2 mt-2 text-white transition-all bg-red-500 rounded-lg hover:bg-red-600"
          >
            Cancel
          </button>
        </div>
      </div>

      <div class="p-0 overflow-scroll">
        <table class="w-full mt-4 text-left table-auto min-w-max">
          <thead>
            <tr>
              <th
                class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
              >
                <p
                  class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                >
                  Member
                </p>
              </th>
              <th
                class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
              >
                <p
                  class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                >
                  Status
                </p>
              </th>
              <th
                class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
              ></th>
              <th
                class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
              ></th>
              <th
                class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
              ></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(employee, index) in employees" :key="index">
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-slate-200': employee.id === userID }"
              >
                <div class="flex items-center gap-3">
                  <div class="flex flex-col">
                    <p class="text-sm font-semibold text-slate-700">
                      {{ employee.username }}
                    </p>
                    <p class="text-sm text-slate-500">{{ employee.email }}</p>
                  </div>
                </div>
              </td>
              <td class="p-4 border-b border-slate-200">
                <!-- Toggle button for Clock In/Out -->
                <label class="switch">
                  <input type="checkbox" v-model="employee.isWorking" @change="handleClockToggle(employee)">
                  <span class="slider round"></span>
                </label>
              </td>
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-slate-200': employee.id === userID }"
              >
                <button
                  @click.stop="
                    openUpdateUserModal(
                      employee.id,
                      employee.username,
                      employee.email
                    )
                  "
                  class="text-sm text-blue-600 hover:underline"
                >
                  Edit
                </button>
              </td>
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-slate-200': employee.id === userID }"
              >
                <button
                  @click.stop="openUserDeleteModal(employee.id)"
                  class="text-sm text-red-600 hover:underline"
                >
                  Delete
                </button>
              </td>
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-slate-200': employee.id === userID }"
              >
                <button
                  @click.stop="$emit('updateUserId', employee.id)"
                  class="text-sm text-green-600 hover:underline"
                >
                  Select
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="flex items-center justify-between p-3">
        <p class="block text-sm text-slate-500">
          Page {{ currentPage }} of {{ totalPages }} ({{ totalUsers }} users)
        </p>
        <div class="flex gap-1">
          <button
            class="rounded border border-slate-300 py-2.5 px-3 text-center text-xs font-semibold text-slate-600 transition-all hover:opacity-75 focus:ring focus:ring-slate-300 active:opacity-[0.85] disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
            type="button"
            @click="previousPage"
            :disabled="currentPage === 1"
          >
            Previous
          </button>
          <button
            class="rounded border border-slate-300 py-2.5 px-3 text-center text-xs font-semibold text-slate-600 transition-all hover:opacity-75 focus:ring focus:ring-slate-300 active:opacity-[0.85] disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
            type="button"
            @click="nextPage"
            :disabled="currentPage === totalPages"
          >
            Next
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import userService from "../userService";
import { useToast } from "vue-toastification";
import CreateUserModal from "./modal/CreateUserModal.vue";

// Méthode pour ouvrir la modale

export default {
  props: ["userID"],
  emits: ["updateUserId", "fetchEmployees"],
  setup() {
    const toast = useToast();
    return { toast };
  },

  name: "EmployeeList",
  data() {
    return {
      employees: [],
      currentPage: 1,
      limit: 5,
      totalPages: 10,
      totalUsers: null,
      showCreateUserModal: false, // Ajout de la variable pour le formulaire
      newUser: {
        username: "",
        email: "",
      },
      error: "",
      showCreateUserModal: false,
      showDeleteUserModal: false,
      showUpdateUserModal: false,
      selectedUserId: null,
      selectedUserEmail: "",
      selectedUserUsername: "",
    };
  },
  methods: {

  // Handle the toggle switch when clock in/out is triggered
    handleClockToggle(employee) {
        // On fait un POST vers /api/clocks/:user_id
        this.toggleClock(employee.id);
      },

    // Méthode pour faire le POST vers /api/clocks/:user_id
    toggleClock(userID) {
      userService
        .toggleClock(userID)
        .then((response) => {
          this.showSuccessToast("Clock action successful!");
          this.fetchEmployees(); // Rafraîchir la liste si nécessaire
        })
        .catch((error) => {
          console.error("Error during clock action:", error);
          this.showErrorToast("Failed to toggle clock.");
        });
    },

    openUserModal() {
      this.showCreateUserModal = true;
    },

    closeUserModal() {
      this.newUser.username = "";
      this.newUser.email = "";
      this.error = "";
      this.showCreateUserModal = false;
    },

    openUserDeleteModal(id) {
      this.showDeleteUserModal = true;
      this.selectedUserId = id;
    },

    closeUserDeleteModal() {
      this.showDeleteUserModal = false;
      this.selectedUserId = null;
    },

    openUpdateUserModal(id, username, email) {
      this.showUpdateUserModal = true;
      this.selectedUserId = id;
      this.newUser.username = username;
      this.newUser.email = email;
    },

    closeUpdateUserModal() {
      this.newUser.username = "";
      this.newUser.email = "";
      this.error = "";
      this.showUpdateUserModal = false;
    },

    selectUser(id) {
      this.selectedUserId = id;
      console.log("Selected user ID:", this.selectedUserId);
      // console.log("userId : ", userID);
    },
    // params in english
    showSuccessToast(message = "Successful operation") {
      this.toast.success(message);
      console.log("this.toast : ", this.toast);
    },
    // params in english
    showErrorToast(message = "An error occurred") {
      this.toast.error(message);
    },
    createUser() {
      const userData = {
        user: {
          username: this.newUser.username,
          email: this.newUser.email,
        },
      };
      console.log("this.$toast : ", this.$toast);

      if (userData.user.username === "" || userData.user.email === "") {
        this.error = "Please fill in all fields.";
        return;
      }

      console.log("Creating user:", userData);

      userService
        .createUser(userData)
        .then((response) => {
          this.employees.push({ ...userData.user, status: "Active" });
          this.newUser.username = "";
          this.newUser.email = "";
          this.error = "";
          this.showCreateUserModal = false;
          this.fetchEmployees();

          if (response.result) {
            // succes toaster
            this.showSuccessToast(response.message);
          } else {
            this.error = response.message;
          }
        })
        .catch((error) => {
          console.error(
            `Error creating user: ${error.response.data.message}`,
            error
          );
          // this.toast.info(error.response.data.message)
          this.error = error.response.data.message;

          // alert("Une erreur s'est produite lors de la création de l'utilisateur.");
        });
    },
    updateUser() {
      const userData = {
        user: {
          username: this.newUser.username,
          email: this.newUser.email,
        },
      };

      console.log("DATATATATA : ", userData);

      if (userData.user.username === "" || userData.user.email === "") {
        this.error = "Please fill in all fields.";
        return;
      }

      console.log("Updating user:", userData);

      userService
        .updateUser(this.selectedUserId, userData)
        .then((response) => {
          const updatedUser = this.employees.find(
            (user) => user.id === this.selectedUserId
          );
          updatedUser.username = userData.user.username;
          updatedUser.email = userData.user.email;
          this.newUser.username = "";
          this.newUser.email = "";
          this.error = "";
          this.showUpdateUserModal = false;
          console.log("User updated successfully:", response);

          if (response.result) {
            // succes toaster
            this.showSuccessToast(response.message);
          } else {
            // error toaster
            // this.showErrorToast(response.message);
            this.error = response.message;
          }
        })
        .catch((error) => {
          console.error(
            `Error updating user: ${error.response.data.message}`,
            error
          );
          // this.toast.info(error.response.data.message)
          this.error = error.response.data.message;
        });
    },

    editEmployee(id) {
      // console.log(`Editing employee with ID: ${id}`);
      this.selectedUserId = id;
      this.showAccountDetails(id);
    },
    showAccountDetails(employeeId) {
      this.$emit("show-account-details", employeeId);
    },
    fetchEmployees() {
      const offset = (this.currentPage - 1) * this.limit;

      console.log(`Fetching employees with limit ${this.limit} and offset ${offset}`);
      userService
        .getUsers(this.limit, offset)
        .then((data) => {
          this.employees = data.users.map(user => ({
            ...user,
            isWorking: user.clock ? user.clock.status : false // Set the clock status
          }));
          this.totalPages = data.total_pages;
          this.totalUsers = data.total_users;
        })
        .catch((error) => {
          console.error("Erreur lors de la récupération des employés:", error);
        });
    },

    nextPage() {
      console.log("Next page");
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.fetchEmployees();
      }
    },
    previousPage() {
      console.log("Previous page");
      if (this.currentPage > 1) {
        this.currentPage--;
        this.fetchEmployees();
      }
    },
    confirmDelete(id) {
      if (confirm("Êtes-vous sûr de vouloir supprimer cet utilisateur ?")) {
        this.deleteEmployee(id);
      }
    },
    deleteEmployee() {
      console.log(`Deleting employee with ID: ${this.selectedUserId}`);
      userService
        .deleteUser(this.selectedUserId)
        .then(() => {
          this.fetchEmployees();
          this.showDeleteUserModal = false;
          this.selectedUserId = null;
          this.toast.success("Employee deleted successfully");
        })
        .catch((error) => {
          console.error("Erreur lors de la suppression de l'employé:", error);
        });
    },
  },
  mounted() {
    this.fetchEmployees();
  },
};
</script>
<style>
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
