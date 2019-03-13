<template lang="pug">
  rest-form(
    title="供給エリア詳細"
    name="district"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
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
        },
        {
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "wheeler_code",
          type: "text",
          label: "託送コード"
        },
        {
          key: "loss_rate_special_high_voltage",
          type: "text",
          label: "損失率(特別高圧)"
        },
        {
          key: "loss_rate_high_voltage",
          type: "text",
          label: "損失率(高圧)"
        },
        {
          key: "loss_rate_low_voltage",
          type: "text",
          label: "損失率(低圧)"
        },
        {
          key: "dlt_host",
          type: "text",
          label: "託送ダウンロード用ホスト名"
        },
        {
          key: "dlt_path",
          type: "text",
          label: "託送ダウンロードパス名"
        },
        {
          key: "is_partial_included",
          type: "text",
          label: "電力量データ部分供給内包有無"
        },
        {
          key: "daytime_start_time_index_id",
          type: "select",
          label: "昼間時間開始時間枠"
        },
        {
          key: "daytime_end_time_index_id",
          type: "select",
          label: "昼間時間終了時間枠"
        },
        {
          key: "peaktime_start_time_index_id",
          type: "select",
          label: "ピークタイム開始時間枠"
        },
        {
          key: "peaktime_end_time_index_id",
          type: "select",
          label: "ピークタイム終了時間枠"
        },
        {
          key: "summer_season_start_month",
          type: "text",
          label: "夏季開始月"
        },
        {
          key: "summer_season_end_month",
          type: "text",
          label: "夏季終了月"
        }
      ],
      options: {
        daytime_start_time_index_id: {},
        daytime_end_time_index_id: {},
        peaktime_start_time_index_id: {},
        peaktime_end_time_index_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/time_indices`)
    .then(result=>{
      let time_indices = result.map(item=>{
        return {
          value: item.id,
          text: item.time
        }
      })
      time_indices.unshift({value: null, text: ""})
      this.options['daytime_start_time_index_id'] = time_indices
      this.options['daytime_end_time_index_id'] = time_indices
      this.options['peaktime_start_time_index_id'] = time_indices
      this.options['peaktime_end_time_index_id'] = time_indices
    })
  }
}
</script>

