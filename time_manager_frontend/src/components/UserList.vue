<template>
  <div class="max-w-[720px] mx-auto">
    <div class="relative flex flex-col w-full h-full text-slate-700 bg-white shadow-md rounded-xl bg-clip-border">
      <div class="relative mx-4 mt-4 overflow-hidden text-slate-700 bg-white rounded-none bg-clip-border">
        <div class="flex items-center justify-between">
          <div>
              <h3 class="text-lg font-semibold text-slate-800">Employees List</h3>
            <p class="text-slate-500">Review each person before edit</p>
          </div>
          <div class="flex flex-col gap-2 shrink-0 sm:flex-row">
            <button
              @click="showCreateUserForm = true"
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

      <div v-if="showCreateUserForm">
        <div class="p-4">
          <p class="text-xl font-extrabold text-zinc-950">New User</p>
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
            User's Name
            <p class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500">(30 characters maximum)</p>
          </label>
          <input
            v-model="newUser.username"
            placeholder="Please enter your full name"
            class="mb-2 flex h-full w-full items-center justify-center rounded-lg border-2 border-gray-400 bg-transparent px-4 py-4 text-zinc-950 shadow-sm outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
            type="text"
          />
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">User's Email</label>
          <input
            v-model="newUser.email"
            placeholder="Please enter your email"
            class="mb-2 flex h-full w-full items-center justify-center rounded-lg border-2 border-gray-400 bg-transparent px-4 py-4 text-zinc-950 shadow-sm outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
            type="text"
          />
          <button
            @click="createUser"
            class="mt-4 w-full rounded-lg bg-blue-500 hover:bg-blue-600 text-white py-2 transition-all"
          >
            Create User
          </button>
          <button
            @click="showCreateUserForm = false"
            class="mt-2 w-full rounded-lg bg-red-500 hover:bg-red-600 text-white py-2 transition-all"
          >
            Cancel
          </button>
        </div>
      </div>

      <div class="p-0 overflow-scroll">
        <table class="w-full mt-4 text-left table-auto min-w-max">
          <thead>
            <tr>
              <th class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100">
                <p class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500">Member</p>
              </th>
              <th class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100">
                <p class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500">Status</p>
              </th>
              <th class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"></th>
              <th class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(employee, index) in employees" :key="index">
              <td class="p-4 border-b border-slate-200">
                <div class="flex items-center gap-3">
                  <div class="flex flex-col">
                    <p class="text-sm font-semibold text-slate-700">{{ employee.username }}</p>
                    <p class="text-sm text-slate-500">{{ employee.email }}</p>
                  </div>
                </div>
              </td>
              <td class="p-4 border-b border-slate-200">
                <p class="text-sm text-slate-500">{{ employee.status || 'N/A' }}</p>
              </td>
              <td class="p-4 border-b border-slate-200">
                <button
                  @click.stop="editEmployee(employee.id)"
                  class="text-blue-600 hover:underline text-sm"
                >
                  Edit
                </button>
              </td>
              <td class="p-4 border-b border-slate-200">
                <button
                  @click.stop="confirmDelete(employee.id)"
                  class="text-red-600 hover:underline text-sm"
                >
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="flex items-center justify-between p-3">
        <p class="block text-sm text-slate-500">Page {{ currentPage }} of {{ totalPages }}</p>
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
import userService from '../userService';

export default {
  name: 'EmployeeList',
  data() {
    return {
      employees: [],
      currentPage: 1,
      limit: 10,
      totalPages: 5,
      showCreateUserForm: false, // Ajout de la variable pour le formulaire
      newUser: {
        username: '',
        email: '',
      },
    };
  },
  methods: {
    createUser() {
    const userData = {
      user: {
        username: this.newUser.username,
        email: this.newUser.email,
      }
    };
    console.log('Creating user:', userData);
    
    userService.createUser(userData)
      .then(() => {
        this.employees.push({ ...userData.user, status: 'Active' });
        this.newUser.username = '';
        this.newUser.email = '';
        this.showCreateUserForm = false;
      })
      .catch(error => {
        console.error('Error creating user:', error);
        alert("Une erreur s'est produite lors de la création de l'utilisateur.");
      });
  },

    editEmployee(id) {
      console.log(`Editing employee with ID: ${id}`);
      this.showAccountDetails(id);
    },
    showAccountDetails(employeeId) {
      this.$emit('show-account-details', employeeId);
    },
    fetchEmployees() {
      const offset = (this.currentPage - 1) * this.limit;
      console.log(`Fetching employees with limit ${this.limit} and offset ${offset}`);
      userService.getUsers(this.limit, offset)
        .then(data => {
          console.log('Employees data:', data);
          this.employees = data.data;
        })
        .catch(error => {
          console.error('Erreur lors de la récupération des employés:', error);
        });
    },
    nextPage() {
      console.log('Next page');
      if (this.currentPage < this.totalPages) {
        this.currentPage++; 
        this.fetchEmployees();
      }
    },
    previousPage() {
      console.log('Previous page');
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
    deleteEmployee(id) {
      console.log(`Deleting employee with ID: ${id}`);
      userService.deleteUser(id)
        .then(() => {
          this.fetchEmployees();
        })
        .catch(error => {
          console.error('Erreur lors de la suppression de l\'employé:', error);
        });
    },
  },
  mounted() {
    this.fetchEmployees();
  },
};
</script>
