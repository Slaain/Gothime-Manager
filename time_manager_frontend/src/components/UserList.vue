<template>
  <div class="max-w-[720px] mx-auto">
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
          placeholder="Username"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          type="text"
        />
        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
          >User's Email</label
        >
        <input
          v-model="newUser.email"
          placeholder="Email"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          type="text"
        />
        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
          >Enter Password
        </label>
        <div class="flex items-center">
          <input
            v-model="newUser.password"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Password"
            class="items-center justify-center flex-grow w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <button
            @click="showPassword = !showPassword"
            type="button"
            class="px-4 py-2 ml-2 text-white bg-blue-500 rounded-lg hover:bg-blue-600"
          >
            {{ showPassword ? "Hide" : "Show" }}
          </button>
        </div>

        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
          Confirm Password
        </label>
        <div class="flex items-center">
          <input
            v-model="newUser.confirmPassword"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Confirm Password"
            class="items-center justify-center flex-grow w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <button
            @click="showPassword = !showPassword"
            type="button"
            class="px-4 py-2 ml-2 text-white bg-blue-500 rounded-lg hover:bg-blue-600"
          >
            {{ showPassword ? "Hide" : "Show" }}
          </button>
        </div>
        <button
          @click="generateRandomPassword"
          class="px-4 py-2 ml-2 text-white bg-blue-500 rounded-lg hover:bg-blue-600"
        >
          Generate random Password
        </button>

        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
          Select Organisation
        </label>
        <select
          v-model="newUser.selectedOrganisation"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="" disabled>Select an organisation</option>
          <option
            v-for="organisation in organisations_list"
            :key="organisation.id"
            :value="organisation.id"
          >
            {{ organisation.name }}
          </option>
        </select>

        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
          Select Role
        </label>
        <select
          v-model="newUser.selectedRole"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="" disabled>Select a role</option>
          <option v-for="role in roles" :key="role.id" :value="role.id">
            {{ role.name }}
          </option>
        </select>

        <p class="h-6 text-red-600">{{ error }}</p>
        <button
          @click="createUser"
          class="w-full py-2 mt-4 text-black transition-all rounded-lg bg-primaryYellow hover:bg-primaryYellow400"
        >
          Create User
        </button>
        <button
          @click="closeUserModal"
          class="w-full py-2 mt-2 text-black transition-all bg-white border rounded-lg hover:bg-neutral-100 border-primaryYellow"
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
          class="w-full py-2 mt-4 text-black transition-all rounded-lg bg-primaryYellow hover:bg-primaryYellow400"
        >
          Update
        </button>
        <button
          @click="closeUpdateUserModal"
          class="w-full py-2 mt-2 text-black transition-all bg-white border rounded-lg border-primaryYellow hover:bg-neutral-100"
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
        <p class="text-black">Are you sure you want to delete this user?</p>
        <p class="h-6 text-red-600">{{ error }}</p>
        <button
          @click="deleteEmployee"
          class="w-full py-2 mt-4 text-black transition-all rounded-lg bg-primaryYellow hover:bg-primaryYellow400"
        >
          Delete
        </button>
        <button
          @click="closeUserDeleteModal"
          class="w-full py-2 mt-2 text-black transition-all bg-white border rounded-lg border-primaryYellow hover:bg-neutral-100"
        >
          Cancel
        </button>
      </div>
    </div>
    <div
      class="relative flex flex-col w-full h-full shadow-md glassmorphism-bg-white text-neutral-100 rounded-xl bg-clip-border"
    >
      <div
        class="relative mx-4 mt-4 overflow-hidden rounded-none text-neutral-100 bg-clip-border"
      >
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-white">Employees List</h3>
            <p class="text-neutral-300">Review each person before edit</p>
          </div>
          <div class="flex flex-col gap-2 shrink-0 sm:flex-row">
            <button
              @click="openUserModal"
              class="flex select-none items-center gap-2 rounded bg-primaryYellow hover:bg-primaryYellow400 py-2.5 px-4 text-xs font-semibold text-black shadow-md shadow-slate-900/10 transition-all hover:shadow-lg hover:shadow-slate-900/20 focus:opacity-[0.85] focus:shadow-none active:opacity-[0.85] active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
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
                :class="{ 'bg-neutral-500/50': employee.id === selectedUserId }"
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
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-neutral-500/50': employee.id === selectedUserId }"
              >
                <!-- Toggle button for Clock In/Out -->
                <label class="switch">
                  <input
                    type="checkbox"
                    v-model="employee.isWorking"
                    @change="handleClockToggle(employee)"
                  />
                  <span class="slider round"></span>
                </label>
              </td>
              <td
                class="p-4 border-b border-slate-200"
                :class="{ 'bg-neutral-500/50': employee.id === selectedUserId }"
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
                :class="{ 'bg-neutral-500/50': employee.id === selectedUserId }"
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
                :class="{ 'bg-neutral-500/50': employee.id === selectedUserId }"
              >
                <button
                  @click.stop="selectUser(employee.id)"
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
import axios from "axios";

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
      organisations_list: [],
      employees: [],
      currentPage: 1,
      limit: 5,
      totalPages: 10,
      totalUsers: null,
      showCreateUserModal: false,
      newUser: {
        username: "",
        email: "",
        password: "",
        confirmPassword: "",
        selectedOrganisation: null,
        selectedRole: null,
      },

      roles: [
        { id: 1, name: "Admin" },
        { id: 2, name: "Manager" },
        { id: 3, name: "Employe" },
      ],
      error: "",
      showPassword: false,
      showCreateUserModal: false,
      showDeleteUserModal: false,
      showUpdateUserModal: false,
      selectedUserId: null,
      selectedUserEmail: "",
      selectedUserUsername: "",
      selectedRole: null,
    };
  },
  methods: {
    generateRandomPassword() {
      const charset =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+~`|}{[]:;?><,./-=";
      let password = "";
      for (let i = 0; i < 12; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        password += charset[randomIndex];
      }
      this.newUser.password = password;
      this.newUser.confirmPassword = password; // Remplit aussi la confirmation de mot de passe
    },

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
          this.getCurrentUsers();
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
      this.$emit("updateUserId", id);
      if (this.selectedUserId === id) {
        this.selectedUserId = null;
        return;
      }
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
      if (this.newUser.password !== this.newUser.confirmPassword) {
        this.error = "Passwords do not match";
        console.log("Passwords do not match");
        return;
      }
      const userData = {
        username: this.newUser.username,
        email: this.newUser.email,
        password: this.newUser.password,
        organisation_id: this.newUser.selectedOrganisation,
        role_id: this.newUser.selectedRole,
      };
      console.log("userData : ", userData);

      if (
        userData.username === "" ||
        userData.email === "" ||
        userData.password === "" ||
        userData.organisation_id === "" ||
        userData.role === ""
      ) {
        this.error = "Please fill in all fields.";
        return;
      }

      userService
        .createUser(userData)
        .then((response) => {
          this.employees.push({ ...userData.user, status: "Active" });
          this.newUser.username = "";
          this.newUser.email = "";
          this.error = "";
          this.showCreateUserModal = false;
          this.fetchEmployees();

          // envoie mail
          axios
            .post(
              "https://time-manager-sendmail.vercel.app/send-email-with-credentials",
              {
                email: userData.email,
                password: userData.password,
              }
            )
            .then((response) => {
              console.log("response : ", response);
            });

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

      if (
        userData.username === "" ||
        userData.email === "" ||
        userData.password === ""
      ) {
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
          updatedUser.username = userData.username;
          updatedUser.email = userData.email;
          this.newUser.username = "";
          this.newUser.email = "";
          this.error = "";
          this.showUpdateUserModal = false;
          this.fetchEmployees();
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
      console.log(`Editing employee with ID: ${id}`);
      this.selectedUserId = id;
      this.showAccountDetails(id);
    },
    showAccountDetails(employeeId) {
      this.$emit("show-account-details", employeeId);
    },
    fetchEmployees() {
      const offset = (this.currentPage - 1) * this.limit;

      console.log(
        `Fetching employees with limit ${this.limit} and offset ${offset}`
      );
      userService
        .getUsers(this.limit, offset)
        .then((data) => {
          this.employees = data.users.map((user) => ({
            ...user,
            isWorking: user.clock ? user.clock.status : false, // Set the clock status
          }));
          this.totalPages = data.total_pages;
          this.totalUsers = data.total_users;
        })
        .catch((error) => {
          console.error("Erreur lors de la récupération des employés:", error);
        });
    },

    fetchOrganisations() {
      console.log("Fetching organisations");
      userService
        .getOrganisations()
        .then((data) => {
          this.organisations_list = data.data;
          console.log(data);
        })
        .catch((error) => {
          console.error(
            "Erreur lors de la récupération des organisations:",
            error
          );
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
    this.fetchOrganisations();
    console.log("this.organisations_list : ", this.organisations_list);
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

.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism-bg-white::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px; /* Épaisseur de la bordure */
  border-radius: 10px; /* Même bordure arrondie */
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.8),
    #ffffff
  ); /* Dégradé entièrement blanc */
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
}

.glassmorphism-bg-white h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}

.glassmorphism-bg-white .line-chart {
  padding: 1rem;
  border-radius: 8px;
}
</style>
