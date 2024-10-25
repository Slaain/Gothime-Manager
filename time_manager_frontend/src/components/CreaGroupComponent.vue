<template>
  <div class="max-w-[720px] mx-auto">
    <div
      class="relative flex flex-col w-full h-full px-6 py-5 bg-white shadow-md text-slate-700 rounded-xl bg-clip-border"
    >
      <!-- Liste des groupes -->
      <div>
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-semibold text-slate-800">Work Groups</h3>
          <button
            @click="openGroupModal"
            class="flex items-center gap-2 rounded bg-slate-800 py-2.5 px-4 text-xs font-semibold text-white shadow-md transition-all hover:shadow-lg"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 24 24"
              class="w-4 h-4"
            >
              <path
                d="M12 4v16m8-8H4"
                stroke-width="2"
                stroke="currentColor"
                fill="none"
              />
            </svg>
            Add Work Group
          </button>
        </div>

        <div v-if="groups.length > 0" class="mt-4">
          <table class="w-full text-left table-auto min-w-max">
            <thead>
              <tr>
                <th class="p-4 border-y border-slate-200 bg-slate-50">Group</th>
                <th class="p-4 border-y border-slate-200 bg-slate-50"></th>
                <th class="p-4 border-y border-slate-200 bg-slate-50"></th>
                <th class="p-4 border-y border-slate-200 bg-slate-50"></th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(group, index) in groups"
                :key="index"
                :class="{
                  'bg-gray-200': selectedGroup && selectedGroup.id === group.id,
                }"
                class="cursor-pointer"
              >
                <td class="p-4 border-b border-slate-200">{{ group.name }}</td>
                <td class="p-4 border-b border-slate-200">
                  <button
                    @click="selectGroup(group)"
                    class="text-sm text-green-600 hover:underline"
                  >
                    Select
                  </button>
                </td>
                <td class="p-4 border-b border-slate-200">
                  <button
                    @click="openEditModal(group)"
                    class="text-sm text-yellow-600 hover:underline"
                  >
                    Edit
                  </button>
                </td>
                <td class="p-4 border-b border-slate-200">
                  <button
                    @click.stop="deleteGroup(group.id)"
                    class="text-sm text-red-600 hover:underline"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Détails du groupe sélectionné et gestion des utilisateurs -->
      <div v-if="selectedGroup" class="pl-5 pr-4">
        <h3 class="text-lg font-semibold text-slate-800">
          Group: {{ selectedGroup.name }}
        </h3>
        <div class="mt-4">
          <h4 class="text-slate-700">Users in this Group</h4>
          <ul>
            <li
              v-for="(user, index) in selectedGroupUsers"
              :key="index"
              class="flex items-center justify-between p-2 border-b"
            >
              <span>{{ user.username }} ({{ user.email }})</span>
              <button
                @click="removeUser(user.id)"
                class="text-sm text-red-600 hover:underline"
              >
                Delete
              </button>
            </li>
          </ul>
        </div>

        <div class="flex items-center justify-between pb-6 mt-4 pr-12-7">
          <h4 class="text-slate-700">Add User</h4>
          <button
            @click="openUserModal"
            class="text-sm text-blue-600 hover:underline"
          >
            Add User
          </button>
        </div>
      </div>

      <!-- Modale de création de groupe -->
      <div
        v-if="showGroupModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white rounded-lg shadow-md">
          <h3 class="mb-4 text-lg font-semibold text-slate-800">
            Create Work Group
          </h3>
          <label class="block mt-2 text-sm font-bold">Group Name</label>
          <input
            v-model="newGroup.name"
            type="text"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <label class="block mt-2 text-sm font-bold"
            >Start Date and Time</label
          >
          <input
            v-model="newGroup.start_date"
            type="datetime-local"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <label class="block mt-2 text-sm font-bold">End Date and Time</label>
          <input
            v-model="newGroup.end_date"
            type="datetime-local"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <div class="flex justify-end gap-4 mt-4">
            <button
              @click="createGroup"
              class="px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600"
            >
              Create
            </button>
            <button
              @click="closeGroupModal"
              class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>

      <!-- Modale de modification du groupe -->
      <div
        v-if="showEditModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white rounded-lg shadow-md">
          <h3 class="mb-4 text-lg font-semibold text-slate-800">
            Edit Work Group
          </h3>
          <label class="block mt-2 text-sm font-bold">Group Name</label>
          <input
            v-model="editGroup.name"
            type="text"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <label class="block mt-2 text-sm font-bold"
            >Start Date and Time</label
          >
          <input
            v-model="editGroup.start_date"
            type="datetime-local"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <label class="block mt-2 text-sm font-bold">End Date and Time</label>
          <input
            v-model="editGroup.end_date"
            type="datetime-local"
            class="w-full p-2 border border-gray-300 rounded"
          />

          <div class="flex justify-end gap-4 mt-4">
            <button
              @click="updateGroup"
              class="px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600"
            >
              Update
            </button>
            <button
              @click="closeEditModal"
              class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>

      <!-- Modale d'ajout d'utilisateur -->
      <div
        v-if="showUserModal"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div class="w-1/2 px-8 py-4 bg-white rounded-lg shadow-md">
          <h3 class="mb-4 text-lg font-semibold text-slate-800">
            Add User to Group
          </h3>
          <Dropdown :users="allUsers" @onUserSelected="setSelectedUser" />
          <div class="flex justify-end gap-4 mt-4">
            <button
              @click="addUserToGroup"
              class="px-4 py-2 text-white bg-green-500 rounded hover:bg-green-600"
            >
              Add
            </button>
            <button
              @click="closeUserModal"
              class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Dropdown from "./Dropdown.vue";
import axios from "axios";

export default {
  components: {
    Dropdown,
  },
  data() {
    return {
      groups: [],
      allUsers: [],
      newGroup: {
        name: "",
        start_date: "",
        end_date: "",
      },
      editGroup: {
        id: null,
        name: "",
        start_date: "",
        end_date: "",
      },
      selectedGroup: null,
      selectedGroupUsers: [],
      selectedUser: null,
      showGroupModal: false,
      showEditModal: false,
      showUserModal: false,
    };
  },
  methods: {
    async selectGroup(group) {
      this.selectedGroup = group;
      try {
        const response = await axios.get(
          `http://localhost:4000/api/groups/${group.id}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.selectedGroupUsers = response.data.data.users || [];
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs du groupe :",
          error
        );
      }
    },
    async addUserToGroup() {
      if (!this.selectedUser) {
        console.error("Aucun utilisateur sélectionné");
        return;
      }
      try {
        await axios.post(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${this.selectedUser}`,
          { headers: { "Content-Type": "application/json" } }
        );
        this.selectGroup(this.selectedGroup);
        this.closeUserModal();
      } catch (error) {
        console.error("Erreur lors de l'ajout d'un utilisateur :", error);
      }
    },
    openGroupModal() {
      this.showGroupModal = true;
    },
    closeGroupModal() {
      this.showGroupModal = false;
    },
    openUserModal() {
      this.showUserModal = true;
    },
    closeUserModal() {
      this.showUserModal = false;
    },
    openEditModal(group) {
      this.editGroup = { ...group };
      this.showEditModal = true;
    },
    closeEditModal() {
      this.showEditModal = false;
      this.editGroup = { id: null, name: "", start_date: "", end_date: "" };
    },
    async updateGroup() {
      try {
        await axios.put(
          `http://localhost:4000/api/groups/${this.editGroup.id}`,
          {
            group: {
              name: this.editGroup.name,
              start_date: this.editGroup.start_date,
              end_date: this.editGroup.end_date,
            },
          },
          {
            headers: { "Content-Type": "application/json" },
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          }
        );
        // Mettre à jour la liste des groupes
        const response = await axios.get("http://localhost:4000/api/groups", {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          },
        });
        this.groups = response.data.data;
        this.closeEditModal();
      } catch (error) {
        console.error("Erreur lors de la mise à jour du groupe :", error);
      }
    },
    async createGroup() {
      try {
        const response = await axios.post(
          "http://localhost:4000/api/groups",
          { group: this.newGroup },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.groups.push(response.data.group);
        this.newGroup = { name: "", start_date: "", end_date: "" };
        this.closeGroupModal();
      } catch (error) {
        console.error("Erreur lors de la création du groupe :", error);
      }
    },
    async deleteGroup(id) {
      try {
        await axios.delete(`http://localhost:4000/api/groups/${id}`, {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          },
        });
        this.groups = this.groups.filter((group) => group.id !== id);
      } catch (error) {
        console.error("Erreur lors de la suppression du groupe :", error);
      }
    },
    setSelectedUser(user) {
      this.selectedUser = user;
    },
    async removeUser(userId) {
      try {
        await axios.delete(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${userId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.selectedGroupUsers = this.selectedGroupUsers.filter(
          (user) => user.id !== userId
        );
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },
  },
  async mounted() {
    try {
      const response = await axios.get(
        "http://localhost:4000/api/groups",
        {},
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          },
        }
      );
      this.groups = response.data.data;
      const usersResponse = await axios.get(
        "http://localhost:4000/api/users",
        {},
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          },
        }
      );
      this.allUsers = usersResponse.data.users || [];
    } catch (error) {
      console.error("Erreur lors de la récupération des données :", error);
    }
  },
};
</script>
