<template lang="pug">
  rest-index(
    title="ユーザー一覧"
    name="users"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="UID"
            label-for="uid"
            )
            b-form-input(
              id="uid"
              v-model="query.uid_cont"
            )
        b-col
          b-form-group(
            label="E-Mail"
            label-for="email"
            )
            b-form-input(
              id="email"
              v-model="query.email_cont"
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
          label: "ID"
        },
        {
          key: "uid",
          label: "UID"
        },
        {
          key: "email",
          label: "E-Mail"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatTime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatTime'
        }
      ],
      query: {
        uid_cont: null,
        email_cont: null
      }
    }
  }
}
</script>

