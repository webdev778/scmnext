<template lang="pug">
  rest-index(
    title="ユーザー一覧"
    name="users"
    v-bind:fields="fields"
    can-edit=true
  )
</template>

<script>
import RestIndex from '~/components/Rest/RestIndex.vue'

export default {
  components: { RestIndex },
  data() {
    return {
      fields: [
        {
          key: "id",
          label: "ID",
          width: 50
        },
        {
          key: "uid",
          label: "uid"
        },
        {
          key: "email",
          label: "E-mail"
        },
        {
          key: "created_at",
          label: "作成日時",
          width: 180
        },
        {
          key: "updated_at",
          label: "更新日時",
          width: 180
        }
      ]
    }
  }
}
</script>

