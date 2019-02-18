<template lang="pug">
  rest-index(
    title="託送ダウンロードファイル一覧"
    name="dlt/files"
    v-bind:fields="fields"
    v-bind:query="query"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="ID:"
            label-for="id"
            )
            b-form-input(id="id" v-model="query.id_eq")
        b-col
          b-form-group(
            label="ファイル名"
            label-for="filename"
            )
            b-form-input(id="status" v-model="query.content_attachment_filename_eq")
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
          key: "filename",
          label: "ファイル名"
        },
        {
          key: "state",
          label: "ステータス"
        },
        {
          key: "created_at",
          label: "作成日時",
          width: 180,
        },
        {
          key: "updated_at",
          label: "更新日時",
          width: 180,
        }
      ],
      query: {
        id_eq: null
      }
    }
  },
  methods: {
    formatStatus(value) {
      console.log(value)
      return value
    }
  }
}
</script>

