<template lang="pug">
  rest-form(
    title="ユーザー詳細"
    name="user"
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
          key: "provider",
          type: "text",
          label: "プロバイダ"
        },
        {
          key: "uid",
          type: "text",
          label: "UID"
        },
        {
          key: "email",
          type: "text",
          label: "E-Mail"
        }
      ]
    }
  }
}
</script>

