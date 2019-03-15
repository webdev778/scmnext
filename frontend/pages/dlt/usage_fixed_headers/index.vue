<template lang="pug">
  rest-index(
    title="確定使用量ヘッダ一覧"
    name="dlt/usage_fixed_headers"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:canEdit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="ファイル"
            label-for="file_id"
            )
            b-form-select(
              id="file_id"
              v-model="query.file_id_eq"
              v-bind:options="files"
            )
        b-col
          b-form-group(
            label="供給地点特定番号"
            label-for="supply_point_number"
            )
            b-form-input(
              id="supply_point_number"
              v-model="query.supply_point_number_cont"
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
          key: "file.content_blob.filename",
          label: "ファイル名"
        },
        {
          key: "supply_point_number",
          label: "供給地点特定番号"
        },
        {
          key: "created_at",
          label: "作成日時"
        },
        {
          key: "updated_at",
          label: "更新日時"
        }
      ],
      query: {
        file_id_eq: null,
        supply_point_number_cont: null
      },
      files: []
    }
  },
  created() {
    this.$axios.$get(`/v1/dlt/files`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.content_blob.filename
        }
      })
      options.unshift({value: null, text: "全て"})
      this.files = options
    })
  }
}
</script>

