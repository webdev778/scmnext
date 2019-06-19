<template lang="pug">
  rest-index(
    title="JEPXインバランスβ値一覧"
    name="jepx/imbalance_betas"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id_eq"
            )
            b-form-select(
              id="district_id_eq"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
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
              id="month_eq"
              v-model="query.month_eq"
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
          key: "district.name",
          label: "エリア名"
        },
        {
          key: "year",
          label: "年",
          width: 50
        },
        {
          key: "month",
          label: "月",
          width: 100
        },
        {
          key: "value",
          label: "値"
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
        district_id_eq: null,
        year_eq: null,
        month_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      districts: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>

