<script setup>
import { Clock, CalendarDays, Bell } from "lucide-vue-next";
</script>

<template>
  <div class="items-center justify-center overflow-x-hidden">
    <div class="flex flex-col items-center w-full background">
      <Header />
      <HeroBanner />
      <div class="flex flex-row items-center justify-around w-full mx-16 mt-24">
        <div
          class="w-1/3 px-6 py-5 border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70"
        >
          <Clock color="white" :size="32" />

          <div class="mt-5">
            <p class="mb-2 text-lg font-bold">Real-time Shift Tracking</p>
            <p>
              Track your shifts in real-time and never miss an important update.
              Know exactly when you're on duty and stay organized.
            </p>
          </div>
        </div>

        <div
          class="w-1/3 px-6 py-5 border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70"
        >
          <CalendarDays color="white" :size="32" />

          <div class="mt-5">
            <p class="mb-2 text-lg font-bold">Real-time Shift Tracking</p>
            <p>
              Track your shifts in real-time and never miss an important update.
              Know exactly when you're on duty and stay organized.
            </p>
          </div>
        </div>

        <div
          class="w-1/3 px-6 py-5 border border-white rounded-md glassmorphism max-w-80 bg-primaryYellow400/70"
        >
          <Bell color="white" :size="32" />

          <div class="mt-5">
            <p class="mb-2 text-lg font-bold">Real-time Shift Tracking</p>
            <p>
              Track your shifts in real-time and never miss an important update.
              Know exactly when you're on duty and stay organized.
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="relative flex flex-col items-center justify-center py-36">
      <p class="w-3/4 text-4xl font-bold text-center">
        The Challenges of Managing Work Attendance
      </p>
      <p class="w-1/2 mt-6 text-center">
        For <span class="font-bold text-primaryYellow">employees</span> and
        <span class="font-bold text-primaryYellow">managers</span> alike,
        keeping track of work hours and attendance can quickly become
        <span class="font-bold text-primaryYellow">chaotic</span>. Manually
        logging hours is prone to
        <span class="font-bold text-primaryYellow">errors</span>, missed
        sign-ins lead to
        <span class="font-bold text-primaryYellow">confusion</span>, and keeping
        track of everyone's location in real-time can be a headache. With
        frequent
        <span class="font-bold text-primaryYellow">schedule changes</span>,
        last-minute
        <span class="font-bold text-primaryYellow">shift adjustments</span>, and
        the risk of
        <span class="font-bold text-primaryYellow">inaccuracies</span>, managing
        attendance becomes a constant challenge, leaving both teams and managers
        <span class="font-bold text-primaryYellow">frustrated</span> and out of
        sync.
      </p>

      <img
        class="absolute -rotate-[25deg] top-36 right-24 size-24"
        src="../assets/images/bat1.png"
      />
      <img
        class="absolute rotate-[35deg] bottom-12 left-24 size-24"
        src="../assets/images/bat1.png"
      />
    </div>
    <div class="flex flex-col items-center justify-center pb-20 bg-[#333333]">
      <p class="w-3/4 mt-20 text-4xl font-bold text-center text-white">
        How Our Solution Simplifies Work Attendance
      </p>

      <div class="flex flex-col w-full gap-8 mt-6">
        <div class="flex flex-row items-center justify-center w-full gap-x-36">
          <div
            class="relative w-1/3 px-6 py-5 overflow-hidden border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70"
          >
            <div class="mt-5">
              <p class="mb-2 text-lg font-bold">
                Quick and Easy Check-In with QR Code
              </p>
              <p>
                Employees can check in by simply scanning a QR code when they
                arrive on site. This eliminates the need for manual sign-ins and
                ensures that attendance is accurately tracked in real-time. No
                more wasted time or missed entries.
              </p>
              <img
                class="absolute bottom-0 right-0 translate-y-[32%] translate-x-[32%] -rotate-45 size-24 opacity-40"
                src="../assets/images/bat1.png"
              />
            </div>
          </div>

          <div
            class="relative w-1/3 px-6 py-5 border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70 hover-3d"
          >
            <div class="mt-5">
              <p class="mb-2 text-lg font-bold">
                Real-Time Location-Based Tracking
              </p>
              <p>
                Ensure that your employees are where they need to be. With
                location-based check-ins, managers can have peace of mind
                knowing that only those who are physically present on site are
                counted. No more remote sign-ins or inaccurate records.
              </p>
              <img
                class="absolute bottom-0 right-0 translate-y-[32%] translate-x-[32%] -rotate-45 size-24 opacity-40"
                src="../assets/images/bat1.png"
              />
            </div>
          </div>
        </div>

        <div class="flex flex-row items-center justify-center w-full gap-x-36">
          <div
            class="absolute w-1/3 px-6 py-5 border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70"
          >
            <div class="mt-5">
              <p class="mb-2 text-lg font-bold">Automatic Shift Reminders</p>
              <p>
                Employees receive automatic reminders for their upcoming shifts,
                ensuring they know exactly when and where they need to be. This
                reduces the chances of missed shifts and helps keep everyone on
                schedule with less confusion.
              </p>
              <img
                class="absolute bottom-0 right-0 translate-y-[32%] translate-x-[32%] -rotate-45 size-24 opacity-40"
                src="../assets/images/bat1.png"
              />
            </div>
          </div>

          <div
            class="absolute w-1/3 px-6 py-5 border border-white rounded-md max-w-80 glassmorphism bg-primaryYellow400/70"
          >
            <div class="mt-5">
              <p class="mb-2 text-lg font-bold">
                Error-Free Attendance Records
              </p>
              <p>
                Say goodbye to disputes about work hours. Our system tracks
                attendance accurately, leaving no room for human error. Both
                employees and managers can access detailed, error-free records,
                making payroll processing and shift management easier than ever.
              </p>
              <img
                class="absolute bottom-0 right-0 translate-y-[32%] translate-x-[32%] -rotate-45 size-24 opacity-40"
                src="../assets/images/bat1.png"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-col items-center justify-center py-24">
      <p class="text-4xl font-bold">How It Works</p>

      <div class="flex items-stretch justify-around w-full h-full mt-12">
        <div class="flex flex-col items-center justify-between w-1/2 my-12">
          <p class="text-xl font-bold">
            Effortless On-Site Check-In with QR Code
          </p>

          <p class="w-3/4 text-center">
            Our solution allows employees to sign in seamlessly by simply
            scanning a QR code when they arrive on site. No more manual time
            tracking or missed sign-ins. With this system, employees can check
            in instantly, ensuring accurate attendance records and eliminating
            confusion or disputes about work hours. It also simplifies shift
            management, saves time for both staff and management, and ensures
            that every team member is where they need to be, when they need to
            be.
          </p>
        </div>

        <div class="relative flex items-center justify-center w-1/2">
          <img
            class="w-1/4 m-2 rounded-lg shadow-2xl"
            src="./../assets/images/Home_.png"
            alt=""
          />
          <img
            class="z-10 w-1/4 m-2 rounded-lg shadow-2xl"
            src="./../assets/images/Scan_.png"
            alt=""
          />
          <img
            class="w-1/4 m-2 rounded-lg shadow-2xl"
            src="./../assets/images/Stats_.png"
            alt=""
          />
        </div>
      </div>
    </div>
    <div
      class="flex flex-col items-center justify-center py-24 bg-primaryYellow"
    >
      <p class="text-4xl font-bold">Testimonials</p>
      <div class="container px-5 py-16 mx-auto mb-4">
        <div class="w-full mx-auto text-center xl:w-1/2 lg:w-3/4">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            class="inline-block w-8 h-8 mb-8 text-white"
            viewBox="0 0 975.036 975.036"
          >
            <path
              d="M925.036 57.197h-304c-27.6 0-50 22.4-50 50v304c0 27.601 22.4 50 50 50h145.5c-1.9 79.601-20.4 143.3-55.4 191.2-27.6 37.8-69.399 69.1-125.3 93.8-25.7 11.3-36.8 41.7-24.8 67.101l36 76c11.6 24.399 40.3 35.1 65.1 24.399 66.2-28.6 122.101-64.8 167.7-108.8 55.601-53.7 93.7-114.3 114.3-181.9 20.601-67.6 30.9-159.8 30.9-276.8v-239c0-27.599-22.401-50-50-50zM106.036 913.497c65.4-28.5 121-64.699 166.9-108.6 56.1-53.7 94.4-114.1 115-181.2 20.6-67.1 30.899-159.6 30.899-277.5v-239c0-27.6-22.399-50-50-50h-304c-27.6 0-50 22.4-50 50v304c0 27.601 22.4 50 50 50h145.5c-1.9 79.601-20.4 143.3-55.4 191.2-27.6 37.8-69.4 69.1-125.3 93.8-25.7 11.3-36.8 41.7-24.8 67.101l35.9 75.8c11.601 24.399 40.501 35.2 65.301 24.399z"
            ></path>
          </svg>
          <p class="text-lg leading-relaxed">
            Thanks to this app, even Gotham's criminals can't escape my
            perfectly organized schedule. Whether it’s saving the city or
            running Wayne Enterprises, I never miss a beat — or a patrol. Alfred
            says I’m finally getting home on time… sometimes.
          </p>
          <span class="inline-block w-10 h-1 mt-8 mb-6 bg-white rounded"></span>
          <h2
            class="text-sm font-medium tracking-wider text-gray-900 title-font"
          >
            Bruce Wayne (Batman)
          </h2>
          <p class="text-gray-500 cursor-pointer">
            CTO at Wayne Enterprises / Gotham's Dark Knight
          </p>
        </div>
      </div>
      <div class="px-5 mx-auto">
        <div class="flex flex-wrap -m-4">
          <div class="p-4 mb-6 lg:w-1/3 lg:mb-0">
            <div class="h-full text-center">
              <p class="leading-relaxed">
                This app is a real lifesaver! Now I can keep track of all my fun
                plans — mayhem, mischief, and misadventures! I used to be all
                over the place, but now? I’m causing chaos and staying on
                schedule. Mr. J would be so proud!
              </p>
              <span
                class="inline-block w-10 h-1 mt-6 mb-4 bg-white rounded"
              ></span>
              <h2
                class="text-sm font-medium tracking-wider text-gray-900 title-font"
              >
                Harley Quinn
              </h2>
              <p class="text-gray-500">
                Chaos Coordinator at Arkham Asylum (Former Employee)
              </p>
            </div>
          </div>
          <div class="p-4 mb-6 lg:w-1/3 lg:mb-0">
            <div class="h-full text-center">
              <p class="leading-relaxed">
                In a city as unpredictable as Gotham, keeping the police force
                organized is no easy task. With this app, I know who’s on duty
                and where they are — it’s almost like having Batman’s help, but
                without the cape and grumbling.
              </p>
              <span
                class="inline-block w-10 h-1 mt-6 mb-4 bg-white rounded"
              ></span>
              <h2
                class="text-sm font-medium tracking-wider text-gray-900 title-font"
              >
                Commissioner James Gordon
              </h2>
              <p class="text-gray-500">
                Head of Operations at Gotham City Police Department (GCPD)
              </p>
            </div>
          </div>
          <div class="p-4 lg:w-1/3 lg:mb-0">
            <div class="h-full text-center">
              <p class="leading-relaxed">
                I’ve got a tight schedule between heists and flirting with
                Batman. This app keeps me on track and makes sure I’m never late
                for… ahem, ‘work.’ Who knew a simple app could make my life so
                much easier?
              </p>
              <span
                class="inline-block w-10 h-1 mt-6 mb-4 bg-white rounded"
              ></span>
              <h2
                class="text-sm font-medium tracking-wider text-gray-900 title-font"
              >
                Selina Kyle (Catwoman)
              </h2>
              <p class="text-gray-500">
                Freelance Cat Burglar and Independent Contractor
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-col items-center justify-center py-24">
      <section class="overflow-hidden text-gray-600 body-font">
        <div class="container px-5 mx-auto">
          <div class="flex flex-col w-full text-center">
            <h1
              class="mb-2 text-3xl font-medium text-gray-900 sm:text-4xl title-font"
            >
              Pricing
            </h1>
            <p class="mx-auto text-base leading-relaxed text-gray-500 lg:w-2/3">
              Surprisingly, all these plans cost you the same — absolutely
              nothing!
            </p>
          </div>
          <div class="flex flex-wrap -m-4">
            <!-- Plan 1: Gotham Citizen -->
            <div class="w-full p-4 xl:w-1/3 md:w-1/2">
              <div
                class="relative flex flex-col h-full p-6 overflow-hidden border-2 border-gray-300 rounded-lg"
              >
                <h2 class="mb-1 text-sm font-medium tracking-widest title-font">
                  GOTHAM CITIZEN
                </h2>
                <h1
                  class="pb-4 mb-4 text-5xl leading-none text-gray-900 border-b border-gray-200"
                >
                  Free
                </h1>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Basic access to all features
                </p>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Perfect for citizens working day shifts
                </p>
                <p class="flex items-center mb-6 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Stay safe during your shifts (hopefully)
                </p>
                <button
                  class="flex items-center w-full px-4 py-2 mt-auto text-white bg-gray-400 border-0 rounded focus:outline-none hover:bg-gray-500"
                >
                  Get Started
                  <svg
                    fill="none"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    class="w-4 h-4 ml-auto"
                    viewBox="0 0 24 24"
                  >
                    <path d="M5 12h14M12 5l7 7-7 7"></path>
                  </svg>
                </button>
                <p class="mt-3 text-xs text-gray-500">
                  No cost. The city has your back.
                </p>
              </div>
            </div>

            <!-- Plan 2: Vigilante Mode -->
            <div class="w-full p-4 xl:w-1/3 md:w-1/2">
              <div
                class="relative flex flex-col h-full p-6 overflow-hidden border-2 rounded-lg border-primaryYellow"
              >
                <span
                  class="absolute top-0 right-0 px-3 py-1 text-xs tracking-widest text-white rounded-bl bg-primaryYellow"
                  >POPULAR</span
                >
                <h2 class="mb-1 text-sm font-medium tracking-widest title-font">
                  VIGILANTE MODE
                </h2>
                <h1
                  class="pb-4 mb-4 text-5xl leading-none text-gray-900 border-b border-gray-200"
                >
                  Free
                </h1>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >For those who work in the shadows
                </p>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Perfect for night shifts (Cape optional)
                </p>
                <p class="flex items-center mb-6 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Stay ahead of Gotham’s crime wave
                </p>
                <button
                  class="flex items-center w-full px-4 py-2 mt-auto text-white border-0 rounded bg-primaryYellow focus:outline-none hover:bg-primaryYellow400"
                >
                  Join the Mission
                  <svg
                    fill="none"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    class="w-4 h-4 ml-auto"
                    viewBox="0 0 24 24"
                  >
                    <path d="M5 12h14M12 5l7 7-7 7"></path>
                  </svg>
                </button>
                <p class="mt-3 text-xs text-gray-500">
                  Completely free — like justice.
                </p>
              </div>
            </div>

            <!-- Plan 3: Supervillain Scheme -->
            <div class="w-full p-4 xl:w-1/3 md:w-1/2">
              <div
                class="relative flex flex-col h-full p-6 overflow-hidden border-2 border-gray-300 rounded-lg"
              >
                <h2 class="mb-1 text-sm font-medium tracking-widest title-font">
                  SUPERVILLAIN SCHEME
                </h2>
                <h1
                  class="pb-4 mb-4 text-5xl leading-none text-gray-900 border-b border-gray-200"
                >
                  Free
                </h1>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >For the more... ambitious individuals
                </p>
                <p class="flex items-center mb-2 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Ideal for complex plots and master plans
                </p>
                <p class="flex items-center mb-6 text-gray-600">
                  <span
                    class="inline-flex items-center justify-center flex-shrink-0 w-4 h-4 mr-2 text-white bg-gray-400 rounded-full"
                  >
                    <svg
                      fill="none"
                      stroke="currentColor"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2.5"
                      class="w-3 h-3"
                      viewBox="0 0 24 24"
                    >
                      <path d="M20 6L9 17l-5-5"></path>
                    </svg> </span
                  >Plan world domination, without the cost
                </p>
                <button
                  class="flex items-center w-full px-4 py-2 mt-auto text-white bg-gray-400 border-0 rounded focus:outline-none hover:bg-gray-500"
                >
                  Start Plotting
                  <svg
                    fill="none"
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    class="w-4 h-4 ml-auto"
                    viewBox="0 0 24 24"
                  >
                    <path d="M5 12h14M12 5l7 7-7 7"></path>
                  </svg>
                </button>
                <p class="mt-3 text-xs text-gray-500">
                  Free, because world domination isn’t cheap.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    <div class="flex flex-col items-center justify-center py-24 bg-[#333333]">
      <section class="">
        <div class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div class="mb-16">
            <h2
              class="text-4xl font-manrope text-center font-bold text-white leading-[3.25rem]"
            >
              Frequently Asked Questions
            </h2>
          </div>
          <div class="accordion-group" data-accordion="default-accordion">
            <!-- Question 1: How can I reset my password? -->
            <div
              class="p-4 mb-8 transition duration-500 border border-gray-300 border-solid accordion rounded-xl accordion-active:bg-yellow-50 accordion-active:border-primaryYellow400 lg:p-4 active"
              id="basic-heading-one-with-icon"
            >
              <button
                class="inline-flex items-center justify-between w-full text-lg font-normal leading-8 text-left text-white transition duration-500 accordion-toggle group hover:text-primaryYellow400 accordion-active:font-medium accordion-active:text-primaryYellow400"
                aria-controls="basic-collapse-one-with-icon"
              >
                <h5>How can I reset my password?</h5>
                <svg
                  class="block w-6 h-6 text-white transition duration-500 origin-center accordion-active:text-primaryYellow400 accordion-active:hidden group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18M12 18V6"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
                <svg
                  class="hidden w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:block group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
              </button>
              <div
                id="basic-collapse-one-with-icon"
                class="w-full pr-4 overflow-hidden accordion-content"
                aria-labelledby="basic-heading-one"
                style="max-height: 250px"
              >
                <p class="text-base font-normal leading-6 text-white">
                  You can reset your password by navigating to the login page
                  and clicking the 'Forgot Password' link. You'll receive an
                  email with instructions to create a new password.
                </p>
              </div>
            </div>

            <!-- Question 2: How do I check in using a QR code? -->
            <div
              class="p-4 mb-8 border border-gray-300 border-solid accordion rounded-xl accordion-active:bg-yellow-50 accordion-active:border-primaryYellow400 lg:p-4"
              id="basic-heading-two-with-icon"
            >
              <button
                class="inline-flex items-center justify-between w-full text-lg font-normal leading-8 text-left text-white transition duration-500 accordion-toggle group hover:text-primaryYellow400 accordion-active:font-medium accordion-active:text-primaryYellow400"
                aria-controls="basic-collapse-two-with-icon"
              >
                <h5>How do I check in using a QR code?</h5>
                <svg
                  class="block w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:hidden group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18M12 18V6"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
                <svg
                  class="hidden w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:block group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
              </button>
              <div
                id="basic-collapse-two-with-icon"
                class="w-full pr-4 overflow-hidden accordion-content"
                aria-labelledby="basic-heading-two"
              >
                <p class="text-base font-normal leading-6 text-white">
                  To check in, simply open the app and scan the QR code provided
                  at your location. Your presence will be automatically logged
                  in real-time.
                </p>
              </div>
            </div>

            <!-- Question 3: How do I receive shift reminders? -->
            <div
              class="p-4 mb-8 border border-gray-300 border-solid accordion rounded-xl accordion-active:bg-yellow-50 accordion-active:border-primaryYellow400 lg:p-4"
              id="basic-heading-three-with-icon"
            >
              <button
                class="inline-flex items-center justify-between w-full text-lg font-normal leading-8 text-left text-white transition duration-500 accordion-toggle group hover:text-primaryYellow400 accordion-active:font-medium accordion-active:text-primaryYellow400"
                aria-controls="basic-collapse-three-with-icon"
              >
                <h5>How do I receive shift reminders?</h5>
                <svg
                  class="block w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:hidden group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18M12 18V6"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
                <svg
                  class="hidden w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:block group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
              </button>
              <div
                id="basic-collapse-three-with-icon"
                class="w-full pr-4 overflow-hidden accordion-content"
                aria-labelledby="basic-heading-three"
              >
                <p class="text-base font-normal leading-6 text-white">
                  You can set shift reminders by going to the settings in the
                  app and enabling notifications for upcoming shifts. You will
                  receive a notification before each shift.
                </p>
              </div>
            </div>

            <!-- Question 4: How do I delete my account? -->
            <div
              class="p-4 mb-8 border border-gray-300 border-solid accordion rounded-xl accordion-active:bg-yellow-50 accordion-active:border-primaryYellow400 lg:p-4"
              id="basic-heading-four-with-icon"
            >
              <button
                class="inline-flex items-center justify-between w-full text-lg font-normal leading-8 text-left text-white transition duration-500 accordion-toggle group hover:text-primaryYellow400 accordion-active:font-medium accordion-active:text-primaryYellow400"
                aria-controls="basic-collapse-four-with-icon"
              >
                <h5>How do I delete my account?</h5>
                <svg
                  class="block w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:hidden group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18M12 18V6"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
                <svg
                  class="hidden w-6 h-6 text-white transition duration-500 accordion-active:text-primaryYellow400 accordion-active:block group-hover:text-primaryYellow400"
                  viewBox="0 0 24 24"
                  fill="none"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M6 12H18"
                    stroke="currentColor"
                    stroke-width="1.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  ></path>
                </svg>
              </button>
              <div
                id="basic-collapse-four-with-icon"
                class="w-full pr-4 overflow-hidden accordion-content"
                aria-labelledby="basic-heading-four"
              >
                <p class="text-base font-normal leading-6 text-white">
                  To delete your account, go to the account settings and select
                  the 'Delete Account' option. Follow the instructions to
                  permanently remove your data.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    <div class="flex flex-col items-center justify-center py-24">
      <div class="container px-5 mx-auto">
        <div
          class="flex flex-col items-start mx-auto lg:w-2/3 sm:flex-row sm:items-center"
        >
          <h1
            class="flex-grow text-2xl font-medium text-gray-900 sm:pr-16 title-font"
          >
            Ready to get started? Sign up today and take control of your work
          </h1>
          <button
            class="flex-shrink-0 px-8 py-2 mt-10 text-lg text-white border-0 rounded bg-primaryYellow focus:outline-none hover:bg-primaryYellow400 sm:mt-0"
          >
            Sign Up
          </button>
        </div>
      </div>
    </div>
    <footer class="pt-24 text-gray-600 body-font bg-primaryYellow">
      <div
        class="container flex flex-col items-center px-5 py-8 mx-auto sm:flex-row"
      >
        <a
          class="flex items-center justify-center font-medium text-gray-900 title-font md:justify-start"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            class="w-10 h-10 p-2 text-white bg-indigo-500 rounded-full"
            viewBox="0 0 24 24"
          >
            <path
              d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"
            ></path>
          </svg>
          <span class="ml-3 text-xl">Goth'time Manager</span>
        </a>
        <p
          class="mt-4 text-sm text-gray-500 sm:ml-4 sm:pl-4 sm:border-l-2 sm:border-gray-200 sm:py-2 sm:mt-0"
        >
          © 2024 Goth'time —
          <a
            href="https://twitter.com/knyttneve"
            class="ml-1 text-gray-600"
            rel="noopener noreferrer"
            target="_blank"
            >@Goth'time</a
          >
        </p>
        <span
          class="inline-flex justify-center mt-4 sm:ml-auto sm:mt-0 sm:justify-start"
        >
          <a class="text-gray-500 cursor-pointer">
            <svg
              fill="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              class="w-5 h-5"
              viewBox="0 0 24 24"
            >
              <path
                d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"
              ></path>
            </svg>
          </a>
          <a class="ml-3 text-gray-500 cursor-pointer">
            <svg
              fill="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              class="w-5 h-5"
              viewBox="0 0 24 24"
            >
              <path
                d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z"
              ></path>
            </svg>
          </a>
          <a class="ml-3 text-gray-500 cursor-pointer">
            <svg
              fill="none"
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              class="w-5 h-5"
              viewBox="0 0 24 24"
            >
              <rect width="20" height="20" x="2" y="2" rx="5" ry="5"></rect>
              <path
                d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37zm1.5-4.87h.01"
              ></path>
            </svg>
          </a>
          <a class="ml-3 text-gray-500 cursor-pointer">
            <svg
              fill="currentColor"
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="0"
              class="w-5 h-5"
              viewBox="0 0 24 24"
            >
              <path
                stroke="none"
                d="M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6zM2 9h4v12H2z"
              ></path>
              <circle cx="4" cy="4" r="2" stroke="none"></circle>
            </svg>
          </a>
        </span>
      </div>
    </footer>
  </div>
  <!-- <div></div> -->
</template>

<script>
import Header from "./LandingPage/Header.vue";
import HeroBanner from "./LandingPage/HeroBanner.vue";
export default {
  components: {
    Header,
    HeroBanner,
  },
};
</script>

<style>
.background {
  background-image: url("./../assets/images/digital-art-with-city-landscape-architecture.png");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 100vh;
}

.glassmorphism {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}

.glassmorphism .line-chart {
  padding: 1rem;
  border-radius: 8px;
}
.hover-3d {
  transition: transform 0.5s ease, box-shadow 0.3s ease;
  transform-style: preserve-3d;
  will-change: transform;
}

/* Effet 3D lors du hover */
.hover-3d:hover {
  transform: perspective(1000px) rotateX(10deg) rotateY(-10deg);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3); /* Légère ombre pour l'effet de profondeur */
}

/* Réinitialise la transformation lorsqu'on sort du hover */
.hover-3d:active {
  transform: perspective(1000px) rotateX(0deg) rotateY(0deg);
}
</style>
