<template>
    <div>
        <h2>Working Time</h2>
        <div v-if="workingTime">
            <p><strong>Start Time:</strong> {{ workingTime.start }}</p>
            <p><strong>End Time:</strong> {{ workingTime.end }}</p>
        </div>
        <div v-else>
            <p>No workingTime data available.</p>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name:(WorkingTime),
    data() {
        return {
            workingTime: null,
        };
    },
    mounted() {
        this.fetchWorkingTime();
    },
    methods: {
        async fetchWorkingTime() {
            try {
                const response = await axios.get()(" /api/workingtime/:userID/:id");
                this.workingTime = response.data;
            } catch (error) {
                console.error('Error fetching workingTime:', error);
            }
        },
    },
};
</script>