<template lang="pug">
  rest-index(
    title="JEPXスポット市場取引結果一覧"
    name="jepx/spot_trades"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="時間枠"
            label-for="time_index_id"
            )
            b-form-select(
              id="time_index_id"
              v-model="query.time_index_id_eq"
              v-bind:options="time_indices"
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
          key: "time_index_id",
          label: "時間枠"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ],
      query: {
        time_index_id_eq: null
      },
      time_indices: []
    }
  },
  created() {
    this.$axios.$get(`/v1/time_indices`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.time
        }
      })
      options.unshift({value: null, text: "全て"})
      this.time_indices = options
    })
  }
}
</script>

