<template lang="pug">
  rest-form(
    title="時間枠詳細"
    name="time_index"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:can-edit="false"
  )
</template>

<script>
import RestForm from '~/components/Rest/RestForm.vue'

export default {
  components: {RestForm},
  data() {
    return {
      id: null,
      fields: [
        {
          key: "id",
          type: "hidden"
        },
        {
          key: "time",
          type: "text",
          label: "時間"
        }
      ]
    }
  }
}
</script>

