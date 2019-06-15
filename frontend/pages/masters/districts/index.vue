<template lang="pug">
  rest-index(
    title="供給エリア一覧"
    name="districts"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名前"
            label-for="name_cont"
            )
            b-form-input(
              id="name_cont"
              v-model="query.name_cont"
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
          key: "name",
          label: "名前"
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
        name_cont: null,
        daytime_start_time_index_id_eq: null,
        daytime_end_time_index_id_eq: null,
        peaktime_start_time_index_id_eq: null,
        peaktime_end_time_index_id_eq: null
      }
    }
  }
}
</script>
