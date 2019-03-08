<template lang="pug">
  rest-form(
    title="施設詳細"
    name="facility"
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
          key: "name",
          type: "text",
          label: "名前"
        }
      ]
    }
  }
}
</script>

