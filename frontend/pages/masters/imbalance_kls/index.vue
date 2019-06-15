<template lang="pug">
  rest-index(
    title="インバランスK値・L値一覧"
    name="imbalance_kls"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="true"
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
            label="開始日From"
            label-for="start_date_gteq"
            )
            b-form-input(
              id="start_date_gteq"
              v-model="query.start_date_gteq"
              type="date"
            )
        b-col
          b-form-group(
            label="開始日To"
            label-for="start_date_lteq"
            )
            b-form-input(
              id="start_date_lteq"
              v-model="query.start_date_lteq"
              type="date"
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
          key: "start_date",
          label: "開始日"
        },
        {
          key: "k_value",
          label: "K値"
        },
        {
          key: "l_value",
          label: "L値"
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
        start_date_gte: null,
        start_date_lte: null
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

