<script setup lang="ts">
import { new_song } from "../models/music";

const config = useRuntimeConfig();

const API_URL = config.public.API_URL;

const music = useState("music", () => null);

(async () => {
  try {
    const response = await $fetch(`${API_URL}/music`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    });

    music.value = response;
    console.log("Updated music state:", music.value);
  } catch (error) {
    console.error("Error fetching music:", error);
    alert("Ocurrio un error al obtener las canciones");
  }
})();
</script>

<template>
  <div>
    <div v-if="!music" class="flex items-center justify-center">
      <h3 class="font-bold">Loading...</h3>
    </div>
    <ul
      id="items_list"
      class="flex flex-col items-center justify-center gap-8 pt-4"
    >
      <li
        v-for="song in music?.songs"
        :key="song.id"
        class="rounded-lg border-black shadow-primary shadow-lg bg-primary_black flex flex-row w-3/4 h-14 text-primary_white mx-auto"
      >
        <p
          class="w-10 h-full flex songs-center justify-center border-r border-r-primary_white rounded-l-lg mr-4 font-semibold p-2"
        >
          {{ song.time_listened }}
        </p>
        <div
          class="w-full grid grid-cols-12 gap-0 justify-songs-start content-center"
        >
          <p class="col-span-7">
            {{ song.title }}
            <label class="text-xs block">
              {{ song.artist }}
              {{ song.album }}
            </label>
          </p>
          <p class="col-span-2 flex songs-center justify-center">
            {{ song.year }}
          </p>
          <p class="col-span-3 flex songs-center justify-center">
            {{ song.quality }}
          </p>
        </div>
        <p class="flex flex-col songs-end justify-end p-2 w-fit">
          <Icon
            v-if="song.icon == 'music'"
            name="material-symbols:play-circle-outline-rounded"
            class="flex songs-center justify-center w-12 h-12"
          />
        </p>
      </li>
    </ul>
  </div>
</template>
