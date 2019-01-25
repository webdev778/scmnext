<template lang="pug">
  rest-form(
    title="ユーザー詳細"
    name="user"
    v-bind:id="id"
    v-bind:fields="fields"
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
          key: "uid",
          type: "text",
          label: "UID"
        },
        {
          key: "email",
          type: "text",
          label: "EMAIL"
        }
      ]
    }
  },
  created() {
    this.id = Number(this.$route.params.id)
  }
}
</script>

