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
            label-for="name"
            )
            b-form-input(
              id="name"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="昼間時間開始時間枠"
            label-for="daytime_start_time_index_id"
            )
            b-form-select(
              id="daytime_start_time_index_id"
              v-model="query.daytime_start_time_index_id_eq"
              v-bind:options="daytime_start_time_indices"
            )
        b-col
          b-form-group(
            label="昼間時間終了時間枠"
            label-for="daytime_start_time_index_id"
            )
            b-form-select(
              id="daytime_end_time_index_id"
              v-model="query.daytime_end_time_index_id_eq"
              v-bind:options="daytime_end_time_indices"
            )
        b-col
          b-form-group(
            label="ピークタイム開始時間枠"
            label-for="peaktime_start_time_index_id"
            )
            b-form-select(
              id="peaktime_start_time_index_id"
              v-model="query.peaktime_start_time_index_id_eq"
              v-bind:options="peaktime_start_time_indices"
            )
        b-col
          b-form-group(
            label="ピークタイム終了時間枠"
            label-for="peaktime_end_time_index_id"
            )
            b-form-select(
              id="peaktime_end_time_index_id"
              v-model="query.peaktime_end_time_index_id_eq"
              v-bind:options="peaktime_end_time_indices"
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
          key: "daytime_start_time_index.time",
          label: "昼間時間開始時間枠"
        },
        {
          key: "daytime_end_time_index.time",
          label: "昼間時間終了時間枠"
        },
        {
          key: "peaktime_start_time_index.time",
          label: "ピークタイム開始時間枠"
        },
        {
          key: "peaktime_end_time_index.time",
          label: "ピークタイム終了時間枠"
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
      },
      daytime_start_time_indices: [],
      daytime_end_time_indices: [],
      peaktime_start_time_indices: [],
      peaktime_end_time_indices: []
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
      this.daytime_start_time_indices = options
      this.daytime_end_time_indices = options
      this.peaktime_start_time_indices = options
      this.peaktime_end_time_indices = options
    })
  }
}
</script>

