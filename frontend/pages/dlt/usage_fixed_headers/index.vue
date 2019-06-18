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
            label="年"
            label-for="year_eq"
            )
            b-form-input(
              id="year_eq"
              v-model="query.year_eq"
            )
        b-col
          b-form-group(
            label="月"
            label-for="month_eq"
            )
            b-form-input(
              id="year_eq"
              v-model="query.month_eq"
            )
        b-col
          b-form-group(
            label="検針日From"
            label-for="record_date_gte"
            )
            b-form-input(
              id="record_date_gte"
              type="date"
              v-model="query.record_date_gte"
            )
        b-col
          b-form-group(
            label="検針日To"
            label-for="record_date_lte"
            )
            b-form-input(
              id="record_date_lte"
              type="date"
              v-model="query.record_date_lte"
            )
        b-col
          b-form-group(
            label="供給地点特定番号"
            label-for="supply_point_number_cont"
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
      query: {
        year_eq: null,
        month_eq: null,
        record_date_gte: null,
        record_date_lte: null,
        supply_point_number_cont: null
      },
      fields: [
        {
          key: "id",
          label: "ID"
        },
        {
          key: "year",
          label: "年",
          width: 100
        },
        {
          key: "month",
          label: "月",
          width: 50
        },
        {
          key: "record_date",
          label: "検針日",
          formatter: "formatDate"
        },
        {
          key: "supply_point_number",
          label: "供給地点特定番号"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: "formatDatetime"
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: "formatDatetime"
        }
      ]
    }
  }
}
</script>

