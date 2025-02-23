<script setup lang="ts">
const config = useRuntimeConfig();

const API_URL = config.public.API_URL;

const fileInput = ref<HTMLInputElement | null>(null);

type new_song = {
  title: string;
  year: string;
  quality: string;
  artist: string;
  album: string;
  time_listened: string;
  icon: string;
  song_file: string;
};

const handleFileChange = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files.length > 0) {
    const new_song = target?.files[0];

    console.log("new_song: ", new_song);

    if (!new_song) {
      alert("Ocurrio un error al subir la canción");
      return;
    }

    const new_song_file = await toBase64(new_song).then((base64File) => {
      let base64 = base64File.split(",")[1];
      return base64;
    });

    if (!new_song_file) {
      alert("Ocurrio un error al procesar la canción");
      return;
    }

    console.log("new_song_file: ", new_song_file);

    uploadFile(new_song, new_song_file);
  }
};

const toBase64 = (file: File): Promise<string> =>
  new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = (error) => reject(error);
  });

const triggerFileInput = () => {
  fileInput.value?.click();
};

const uploadFile = async (song_data: File, song_file: string) => {
  const new_song_body: new_song = {
    title: song_data.name.split(" ")[2] || "desconocido",
    year: song_data.lastModified.toString().split(" ")[3] || "no data",
    quality: "1400",
    artist: song_data.name.split(" ")[0] || "quien sabe",
    album: "proximamente",
    time_listened: "450",
    icon: "music",
    song_file: song_file,
  };

  const body = {
    new_song: new_song_body,
  };

  const new_song_body_stringificado = JSON.stringify(body);

  console.log("body: ", new_song_body_stringificado);

  try {
    await fetch(`${API_URL}/music/load`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: new_song_body_stringificado,
    }).then((response) => {
      console.log("response: ", response);
      alert("Canción subida correctamente");
    });
  } catch (error) {
    console.log("error: ", error);
    alert("Hubo un error al subir el archivo");
  }
};
</script>
<template>
  <div
    class="flex flex-col items-center justify-start mt-4 min-w-full min-h-full"
  >
    <div class="flex flex-row items-center justify-center mb-8">
      <h1>Welcome Rubén</h1>
    </div>
    <div
      class="flex flex-row items-center justify-center min-w-full min-h-full gap-12"
    >
      <div
        class="border shadow-lg shadow-primary rounded-2xl bg-primary_black w-1/2"
      >
        <div
          class="text-primary_white text-lg p-2 pl-3 font-semibold hover:cursor-pointer"
        >
          <input
            ref="fileInput"
            id="fileInput"
            type="file"
            class="hidden"
            name="music"
            @change="handleFileChange"
          />
          <p>Upload New Music</p>
          <p
            class="flex items-center justify-center mt-3"
            @click="triggerFileInput"
          >
            <Icon
              class="flex w-24 h-24"
              name="material-symbols:drive-folder-upload"
            />
          </p>
        </div>
      </div>
      <div
        class="border shadow-lg shadow-primary rounded-2xl bg-primary_black w-1/2"
      >
        <NuxtLink to="/music">
          <div
            class="text-primary_white text-lg p-2 pl-3 font-semibold hover:cursor-pointer"
          >
            <p>Go to your music</p>
            <p class="flex items-center justify-center mt-3">
              <Icon
                class="flex w-24 h-24"
                name="material-symbols:library-music"
              />
            </p>
          </div>
        </NuxtLink>
      </div>
    </div>
  </div>
</template>
