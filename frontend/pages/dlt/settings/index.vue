<template lang="pug">
  rest-index(
    title="ダウンロード設定一覧"
    name="dlt/settings"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:canEdit="true"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="BG名"
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
            label="状態"
            label-for="state_eq"
            )
            b-form-select(
              id="state_eq"
              v-model="query.state_eq"
              v-bind:options="states"
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
          label: "BG名"
        },
        {
          key: "bg_member.company.name",
          label: "PPS名"
        },
        {
          key: "state_i18n",
          label: "状態"
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
        bg_member_balancing_group_id_eq: null,
        bg_member_company_id_eq: null,
        state_eq: null
      },
      balancing_groups: [],
      companies: [],
      states: []
    }
  },
  created() {
    this.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.balancing_groups = result
    })
    this.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.companies = result
    })
    this.$restApi.enums('dlt/settings', 'states', {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.states = result
    })
  }
}
</script>

