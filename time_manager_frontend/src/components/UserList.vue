<template>
    <div class="max-w-[720px] mx-auto">
      <div class="block mb-4 mx-auto border-b border-slate-300 pb-2 max-w-[360px]">
        <a
          target="_blank"
          href="https://www.material-tailwind.com/docs/html/table"
          class="block w-full px-4 py-2 text-center text-slate-700 transition-all"
        >
          More components on <b>Material Tailwind</b>.
        </a>
      </div>
  
      <div class="relative flex flex-col w-full h-full text-slate-700 bg-white shadow-md rounded-xl bg-clip-border">
        <div class="relative mx-4 mt-4 overflow-hidden text-slate-700 bg-white rounded-none bg-clip-border">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-lg font-semibold text-slate-800">Employees List</h3>
              <p class="text-slate-500">Review each person before edit</p>
            </div>
            <div class="flex flex-col gap-2 shrink-0 sm:flex-row">
              <button
                class="rounded border border-slate-300 py-2.5 px-3 text-center text-xs font-semibold text-slate-600 transition-all hover:opacity-75 focus:ring focus:ring-slate-300 active:opacity-[0.85] disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none"
                type="button"
              >
                View All
              </button>
              <button
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
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      aria-hidden="true"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                      ></path>
                    </svg>
                  </p>
                </th>
                <th
                  class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
                >
                  <p
                    class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                  >
                    Function
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      aria-hidden="true"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                      ></path>
                    </svg>
                  </p>
                </th>
                <th
                  class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
                >
                  <p
                    class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                  > 
                    Status
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      aria-hidden="true"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                      ></path>
                    </svg>
                  </p>
                </th>
                <th
                  class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
                >
                  <p
                    class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                  >
                    Employed
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="2"
                      stroke="currentColor"
                      aria-hidden="true"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9"
                      ></path>
                    </svg>
                  </p>
                </th>
                <th
                  class="p-4 transition-colors cursor-pointer border-y border-slate-200 bg-slate-50 hover:bg-slate-100"
                >
                  <p
                    class="flex items-center justify-between gap-2 font-sans text-sm font-normal leading-none text-slate-500"
                  >
                  </p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(employee, index) in employees" :key="index">
                <td class="p-4 border-b border-slate-200">
                  <div class="flex items-center gap-3">
                    <div class="flex flex-col">
                      <p class="text-sm font-semibold text-slate-700">{{ employee.name }}</p>
                      <p class="text-sm text-slate-500">{{ employee.email }}</p>
                    </div>
                  </div>
                </td>
                <td class="p-4 border-b border-slate-200">
                  <p class="text-sm text-slate-500">{{ employee.status }}</p>
                </td>
                <td class="p-4 border-b border-slate-200 text-right">
                  <button
                    class="text-slate-600 hover:text-slate-900 transition-all"
                    @click="editEmployee(employee.id)"
                  >
                    Edit
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'EmployeeList',
    props: {
      employees: {
        type: Array,
        required: true,
      },
    },
    methods: {
      editEmployee(id) {
        console.log(`Editing employee with ID: ${id}`);
      },
      fetchEmployees() {
      const limit = 10;
      const offset = 0;
      userService.getUsers(limit, offset)
        .then(data => {
          this.employees = data;
        })
        .catch(error => {
          console.error('Erreur lors de la récupération des employés:', error);
        });
    },
    },
  };
  </script>
  
  <style scoped>
  </style>
  