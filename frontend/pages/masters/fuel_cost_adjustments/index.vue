<template lang="pug">
  rest-index(
    title="燃料調整費一覧"
    name="fuel_cost_adjustments"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="バランシンググループ名"
            label-for="bg_member_balancing_group_id_eq"
            )
            b-form-select(
              id="bg_member_balancing_group_id_eq"
              v-model="query.bg_member_balancing_group_id_eq"
              v-bind:options="balancing_groups"
            )
        b-col
          b-form-group(
            label="PPS名"
            label-for="bg_member_company_id_eq"
            )
            b-form-select(
              id="bg_member_company_id_eq"
              v-model="query.bg_member_company_id_eq"
              v-bind:options="companies"
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
          key: "bg_member.balancing_group.name",
          label: "バランシンググループ名"
        },
        {
          key: "bg_member.company.name",
          label: "PPS名"
        },
        {
          key: "year",
          label: "年"
        },
        {
          key: "month",
          label: "月"
        },
        {
          key: "unit_price",
          label: "単価"
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
        bg_member_balancing_group_id_eq: null,
        bg_member_company_id_eq: null,
        year_eq: null,
        month_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      balancing_groups: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'}),
      companies: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>

